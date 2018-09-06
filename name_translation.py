import re

"""Translate FRAX00 names to Species names"""

translation = dict([
    (1, 'Solanum_lycopersicum'),
    (2, 'Mimulus_guttatus'),
    (3, 'Olea_europaea'),
    (4, 'F_angustifolia_Frax01'),
    (5, 'F_mandshurica_Frax06'),
    (6, 'F_nigra_Frax23'),
    (7, 'F_excelsior_BATG0.5'),
    (8, 'F_angustifolia_subsp_syriaca_Frax16'),
    (9, 'F_angustifolia_subsp_oxycarpa_Frax15'),
    (10, 'F_griffithii_Frax21'),
    (11, 'F_cuspidata_Frax31'),
    (12, 'F_platypoda_Frax33'),
    (13, 'F_caroliniana_Frax03'),
    (14, 'F_pennsylvanica_Frax10'),
    (15, 'F_velutina_Frax13'),
    (16, 'F_albicans_Frax26'),
    (17, 'F_americana_Frax14'),
    (18, 'F_latifolia_Frax05'),
    (19, 'F_pennsylvanica_Frax09'),
    (20, 'F_goodingii_Frax19'),
    (21, 'F_greggii_Frax20'),
    (22, 'F_quadrangulata_Frax11'),
    (23, 'F_dipetala_Frax04'),
    (24, 'F_anomala_Frax27'),
    (25, 'F_xanthoxyloides_Frax25'),
    (26, 'F_paxiana_Frax08'),
    (27, 'F_baroniana_Frax28'),
    (28, 'F_sieboldiana_Frax12'),
    (29, 'F_ornus_Frax07'),
    (30, 'F_bungeana_Frax29'),
    (31, 'F_chinensis_Frax30'),
    (32, 'F_floribunda_Frax32')])
aliases = [
    (1,  '"Solanum lycopersicum"', 'Slycopersicum'),
    (2,  '"Mimulus guttatus"',   'Mguttatus'),
    (3,  '"Olea europaea"',      'Oeuropea'),
    (4,  '"F. angustifolia"','FRAX01'),
    (5,  '"F. mandshurica"','FRAX06'),
    (6,  '"F. nigra"','FRAX23'),
    (7,  '"F. excelsior"','FRAX00'),
    (8,  '"F. angustifolia subsp syriaca"','FRAX16'),
    (9,  '"F. angustifolia subsp oxycarpa"','FRAX15'),
    (10, '"F. griffithii"','FRAX21'),
    (11, '"F. cuspidata"','FRAX31'),
    (12, '"F. platypoda"','FRAX33'),
    (13, '"F. caroliniana"','FRAX03'),
    (14, '"F. pennsylvanica"','FRAX10'),
    (15, '"F. velutina"','FRAX13'),
    (16, '"F. albicans"','FRAX26'),
    (17, '"F. americana"','FRAX14'),
    (18, '"F. latifolia"','FRAX05'),
    (19, '"F. pennsylvanica"','FRAX09'),
    (20, '"F. goodingii"','FRAX19'),
    (21, '"F. greggii"','FRAX20'),
    (22, '"F. quadrangulata"','FRAX11'),
    (23, '"F. dipetala"','FRAX04'),
    (24, '"F. anomala"','FRAX27'),
    (25, '"F. xanthoxyloides"','FRAX25'),
    (26, '"F. paxiana"','FRAX08'),
    (27, '"F. baroniana"','FRAX28'),
    (28, '"F. sieboldiana"','FRAX12'),
    (29, '"F. ornus"','FRAX07'),
    (30, '"F. bungeana"','FRAX29'),
    (31, '"F. chinensis"','FRAX30'),
    (32, '"F. floribunda"','FRAX32')]
speciesID = {
    '0': 'FRAX00',
    '1': 'FRAX01',
    '2': 'FRAX02',
    '3': 'FRAX03',
    '4': 'FRAX04',
    '5': 'FRAX05',
    '6': 'FRAX06',
    '7': 'FRAX07',
    '8': 'FRAX08',
    '9': 'FRAX09',
    '10': 'FRAX11',
    '11': 'FRAX12',
    '12': 'FRAX13',
    '13': 'FRAX14',
    '14': 'FRAX15',
    '15': 'FRAX16',
    '16': 'FRAX19',
    '17': 'FRAX20',
    '18': 'FRAX21',
    '19': 'FRAX23',
    '20': 'FRAX25',
    '21': 'FRAX26',
    '22': 'FRAX27',
    '23': 'FRAX28',
    '24': 'FRAX29',
    '25': 'FRAX30',
    '26': 'FRAX31',
    '27': 'FRAX32',
    '28': 'FRAX33',
    '29': 'FRAX34',
    '30': 'Mguttatus',
    '31': 'Oeuropea',
    '32': 'Slycopersicum',
}

def with_aliases(file_str):
    for id, full_name, short in aliases:
        full_name_no_quotes = full_name.replace('"', '').replace('.', '').replace(' ', '_')
        file_str = file_str.replace(short, full_name_no_quotes)
    return file_str

def with_speciesID(file_str):
    for id, frax_name in speciesID.items():
        file_str = file_str.replace('(' + id + ':', '(' + frax_name + ':')
        file_str = file_str.replace(',' + id + ':', ',' + frax_name + ':')

    return file_str

def do_transform(filename):
    import os
    file_str = open(filename, 'r').read()
    transformed = with_aliases(file_str)
    print(transformed)
    file, ext = os.path.splitext(filename)
    open(file + '__translated' + ext, 'w').write(transformed)

if __name__ == "__main__":
    # filename = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\data\cafe_prototype\reports\summary\run8_summary__all_lambda_003__mu_012_pub.csv"
    # filename = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\data\cafe_prototype\reports\run8_internal_labels.tre"
    # filename = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\Ash_Proteome\Results_Jun25\RAxML_result.SpeciesTree"
    do_transform(r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\CAFE-4.1\data\cafe_orthofinder\graph_tree.bat")
    do_transform(r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\CAFE-4.1\data\cafe_orthofinder\reports\WGD_rates_loose_summary_node.txt")


    # tree = "(((((((((((1:10.000,2:10.000):5.549,3:10.000):1.778,((11:10.000,(12:10.000,(((((13:10.000,19:10.000):0.206,14:10.000):0.144,15:10.000):0.202,(16:10.000,17:10.000):0.821):0.298,18:10.000):3.352):1.709):0.049,((22:10.000,24:10.000):0.350,23:10.000):4.122):0.064):0.013,(20:10.000,21:10.000):4.387):1.030,10:10.000):0.874,(((((4:10.000,8:10.000):0.133,9:10.000):0.228,7:10.000):0.770,(5:10.000,6:10.000):0.169):4.279,25:10.000):0.028):2.893,26:10.000):0.290,(29:10.000,30:10.000):0.849):0.368,28:10.000):0.201,27:10.000):1.325,31:10.000,32:10.000);"
# translated = editable_str(tree)
# this = re.finditer(r'(\(\d\d?|,\d\d?)', tree)
# for match in this:
#     orig = match.group(1)
#     coerce = int(orig.replace('(', '').replace(',', ''))
#     print(orig, coerce)
#     translated.remove()