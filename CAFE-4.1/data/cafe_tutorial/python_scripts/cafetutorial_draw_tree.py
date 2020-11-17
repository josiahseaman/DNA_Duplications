#!/usr/bin/env python

from Bio import Phylo
from cStringIO import StringIO
import matplotlib
from matplotlib import pyplot as plt
import csv
import argparse
import os

colors = dict(Expansions='green', Contractions='red', Rapid='blue', Gains='green', Losses='red')

labels = dict()

def display(tree_type):
    d = {'Rapid': 'Rapidly evolving families',
         'Gains': 'Expansions',
         'Losses': 'Contractions'}
    if tree_type in d:
        return d[tree_type]
    else:
        return tree_type


def label(n):
    family_count = n.info
    if n.name:
        return "%s (%s)" % (n.name, family_count)

    else:
        return family_count


def combo_label(n):
    numerical_part = "+%s -%s" % (n.gains, n.losses)
    if n.name:
        return "%s (%s)" % (n.name, numerical_part)

    else:
        return numerical_part


def prettify_tree(fig):
    plt.ylabel('')
    plt.tick_params(
        axis='y',  # changes apply to the y-axis
        which='both',  # both major and minor ticks are affected
        left='off',  # ticks along the left edge are off
        right='off',  # ticks along the right edge are off
        labelleft='off')  # labels along the left edge are off

    [fig.gca().spines[border].set_visible(False) for border in ['left', 'right', 'top']]

def draw_tree(datafile, tree_type, newick, node_ids, output_file):
    with open(datafile) as f:
        reader = csv.DictReader(f, delimiter='\t')

        for row in reader:
            labels[row["Node"]] = row

    tree = Phylo.read(StringIO(newick), "newick")
    id_tree = Phylo.read(StringIO(node_ids), "newick")

    for clade, c_id in zip(tree.find_clades(), id_tree.find_clades()):
        clade.info = labels[c_id.name][display(tree_type)] if c_id.name in labels else ""

    tree.ladderize()   # Flip branches so deeper clades are displayed at top

    plt.ion()
    matplotlib.rc('font', size=6,)# backgroundcolor='silver')
    fig = plt.figure(frameon=False)
    Phylo.draw(tree, axes=fig.gca(), do_show=False, label_func=label, label_colors = lambda n: colors[tree_type])
    plt.title(display(tree_type) + " (count)")
    prettify_tree(fig)
    plt.ioff()

    if output_file:
        fig.savefig(output_file, format='png', bbox_inches='tight', dpi=300)

    else:
        plt.show()


def draw_combo_tree(datafile, newick, node_ids, output_file):
    with open(datafile) as f:
        reader = csv.DictReader(f, delimiter='\t')

        for row in reader:
            labels[row["Node"]] = row

    tree = Phylo.read(StringIO(newick), "newick")
    id_tree = Phylo.read(StringIO(node_ids), "newick")

    for clade, c_id in zip(tree.find_clades(), id_tree.find_clades()):
        clade.gains = labels[c_id.name][display('Gains')] if c_id.name in labels else ""
        clade.losses = labels[c_id.name][display('Losses')] if c_id.name in labels else ""

    tree.ladderize()   # Flip branches so deeper clades are displayed at top

    plt.ion()
    matplotlib.rc('font', size=8,)# backgroundcolor='silver')
    fig = plt.figure(frameon=False, figsize=((15,11)))
    Phylo.draw(tree, axes=fig.gca(), do_show=False, label_func=combo_label, label_colors=lambda n:'blue')
    plt.title("Gene Gains (+) and Losses (-)")
    prettify_tree(fig)
    plt.ioff()

    fig.savefig(output_file, format='png',
                bbox_inches='tight',
                dpi=300)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, prog="draw_expansion_tree.py")
    parser.add_argument("-i", "--input-file", action="store", dest="input_file", required=True, type=str, help="full path to mcl's output dump file")
    parser.add_argument("-t", "--tree", action="store", dest="tree", required=True, help="Newick tree to display")
    parser.add_argument("-d", "--ids", action="store", dest="id_tree", required=True, help="Matching Newick tree with node IDs")
    parser.add_argument("-y", "--tree-type", action="store", dest="tree_type", default="Expansions", required=False, type=str, help="Expansions, Contractions, Rapid, Gains, Losses")
    parser.add_argument("-o", "--output-file", action="store", dest="output_file", required=False, type=str, help="output PNG file name")

    args = parser.parse_args()

    if not os.path.isfile(args.input_file):
        exit("Could not find input file. Exiting...\n")

    if args.tree_type == 'combo':
        draw_combo_tree(args.input_file, args.tree, args.id_tree, args.output_file)
    else:
        draw_tree(args.input_file, args.tree_type, args.tree, args.id_tree, args.output_file)

    """python python_scripts/cafetutorial_draw_tree.py -i reports/summary_run1_node.txt -t "((((cat:68.7105,horse:68.7105):4.56678,cow:73.2773):20.7227,(((((chimp:4.44417,human:4.44417):6.68268,orang:11.1268):2.28586,gibbon:13.4127):7.21153,(macaque:4.56724,baboon:4.56724):16.057):16.0607,marmoset:36.6849):57.3151):38.738,(rat:36.3024,mouse:36.3024):96.4356)" -d "((((cat<0>,horse<2>)<1>,cow<4>)<3>,(((((chimp<6>,human<8>)<7>,orang<10>)<9>,gibbon<12>)<11>,(macaque<14>,baboon<16>)<15>)<13>,marmoset<18>)<17>)<5>,(rat<20>,mouse<22>)<21>)<19>" -o reports/summary_run1_tree_rapid.png -y Rapid"""
    """-i ../cafe_orthofinder/reports/WGD_rates_loose_summary_node.txt -t "(((((((((((FRAX30:2,FRAX32:2):1,FRAX28:3):2,FRAX12:5):4,(FRAX07:8,FRAX29:8):1):4,FRAX08:13):1,(((((FRAX01:2,FRAX16:2):4,FRAX15:6):2,FRAX00:8):2,(FRAX06:9,FRAX23:9):1):3,FRAX25:13):1):3,FRAX21:17):2,(((FRAX19:8,FRAX20:8):2,((FRAX11:5,FRAX27:5):4,FRAX04:9):1):1,(((((FRAX03:1,FRAX09:1):1,FRAX13:2):2,(FRAX26:2,FRAX14:2):2):3,FRAX05:7):2,FRAX33:9):2):8):15,FRAX31:34):2,Oeuropea:36):43,(Slycopersicum:37,Mguttatus:37):42)" -d "(((((((((((FRAX30<0>,FRAX32<2>)<1>,FRAX28<4>)<3>,FRAX12<6>)<5>,(FRAX07<8>,FRAX29<10>)<9>)<7>,FRAX08<12>)<11>,(((((FRAX01<14>,FRAX16<16>)<15>,FRAX15<18>)<17>,FRAX00<20>)<19>,(FRAX06<22>,FRAX23<24>)<23>)<21>,FRAX25<26>)<25>)<13>,FRAX21<28>)<27>,(((FRAX19<30>,FRAX20<32>)<31>,((FRAX11<34>,FRAX27<36>)<35>,FRAX04<38>)<37>)<33>,(((((FRAX03<40>,FRAX09<42>)<41>,FRAX13<44>)<43>,(FRAX26<46>,FRAX14<48>)<47>)<45>,FRAX05<50>)<49>,FRAX33<52>)<51>)<39>)<29>,FRAX31<54>)<53>,Oeuropea<56>)<55>,(Slycopersicum<58>,Mguttatus<60>)<59>)<57>" -o ../cafe_orthofinder/reports/WGD_rates_loose_tree_rapid.png -y Rapid"""