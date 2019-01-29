import subprocess
import multiprocessing
from datetime import datetime
import os
from os.path import dirname, join, basename
from Bio.Align.Applications import MuscleCommandline
from DNASkittleUtils.CommandLineUtils import just_the_name
from glob import glob


def do_alignment(args):
    #     print("starting alignment")
    index, fa, output_folder = args
    target = join(output_folder, just_the_name(fa) + '.fa')
    muscle_exe = 'muscle3.8.31_i86win32.exe'

    if not os.path.exists(target):
        muscle_cline = MuscleCommandline(muscle_exe, input=fa, out=target)
        try:
            stdout, stderr = muscle_cline()
        except subprocess.CalledProcessError as err:
            print(err.stderr)
        print(datetime.now(), just_the_name(fa), '{:%}'.format(index / 64652))


def batch_align_sequences(input_folder, output_folder):
    start = datetime.now()
    input_folder = os.path.abspath(input_folder)
    os.makedirs(output_folder, exist_ok=True)
    files = glob(os.path.join(input_folder, '*.fa'))
    files = sorted(files, key=os.path.getsize)
    args = [(i, ipath, output_folder) for i, ipath in list(enumerate(files))]
    #for line in args:
    #    do_alignment(line)
    pool.map(do_alignment, args)
    print("Alignment took ", datetime.now() - start)

    return os.path.abspath(output_folder)

# You can't actually do multiprocessing from a notebook
if __name__ == '__main__':  # https://github.com/jupyter/notebook/issues/2080
    pool = multiprocessing.Pool(6)
    #
    # family_aligned_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\Ash_Proteome\Results_Jun25\Orthologues_Jul06\Sequences\test\aligned"
    # family_fasta_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\Ash_Proteome\Results_Jun25\Orthologues_Jul06\Sequences\test"
    family_aligned_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\Ogs\Jun25\Sequences\aligned"
    family_fasta_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\Ogs\Jun25\Sequences"

    batch_align_sequences(input_folder=family_fasta_dir,
                          output_folder=family_aligned_dir)