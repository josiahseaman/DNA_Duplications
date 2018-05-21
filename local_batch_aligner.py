import subprocess
import multiprocessing
from datetime import datetime
import os
from os.path import dirname, join, basename
from Bio.Align.Applications import MuscleCommandline
from DNASkittleUtils.CommandLineUtils import just_the_name
from glob import glob


def do_alignment(args):
    index, fa = args
    target = join(dirname(fa), 'aligned', just_the_name(fa) + '.fa')
    muscle_exe = 'muscle3.8.31_i86win32.exe'

    if not os.path.exists(target):
        muscle_cline = MuscleCommandline(muscle_exe, input=fa, out=target)
        try:
            stdout, stderr = muscle_cline()
        except subprocess.CalledProcessError as err:
            print(err.stderr)
        print(datetime.now(), just_the_name(fa), '{:%}'.format(index / 5244))


def batch_align_sequences(input_folder, output_folder):
    start = datetime.now()
    input_folder = os.path.abspath(input_folder)
    os.makedirs(output_folder, exist_ok=True)
    files = glob(os.path.join(input_folder, '*.fa'))
    pool.map(do_alignment, list(enumerate(files)))

    return os.path.abspath(output_folder)


if __name__ == '__main__':  # https://github.com/jupyter/notebook/issues/2080
    pool = multiprocessing.Pool(10)
    family_aligned_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\data\super_hog_test_viz\aligned"
    family_fasta_dir = r"D:\josiah\Documents\Research\Thesis - Genome Symmetry\DNA_Duplications\data\super_hog_test_viz"

    batch_align_sequences(input_folder=family_fasta_dir,
                          output_folder=family_aligned_dir)