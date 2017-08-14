class Contig:
    def __init__(self, name, seq):
        self.name = name
        self.seq = seq
        
    def __repr__(self):
        return '< "%s" %i nucleotides>' % (self.name, len(self.seq))

def read_contigs(input_file_path):
    contigs = []
    current_name = ""
    seq_collection = []

    # Pre-read generates an array of contigs with labels and sequences
    with open(input_file_path, 'r') as streamFASTAFile:
        for read in streamFASTAFile.read().splitlines():
            if read == "":
                continue
            if read[0] == ">":
                # If we have sequence gathered and we run into a second (or more) block
                if len(seq_collection) > 0:
                    sequence = "".join(seq_collection)
                    seq_collection = []  # clear
                    contigs.append(Contig(current_name, sequence))
                current_name = read[1:]  # remove >
            else:
                # collects the sequence to be stored in the contig, constant time performance don't concat strings!
                seq_collection.append(read.upper())

    # add the last contig to the list
    sequence = "".join(seq_collection)
    contigs.append(Contig(current_name, sequence))
    return contigs

# read_contigs('data\\random_olig6.fa')[0].seq[:1000]
# len(read_contigs('data/33488897.fasta')[0].seq)

