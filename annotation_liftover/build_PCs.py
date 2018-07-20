#!/lustre/projects/staton/software/Anaconda2-2.5.0/bin/python
import re, sys, getopt
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
from os.path import splitext

fasta_file = "fraxinus_pennsylvanica_20Feb2018_lPmM4.fasta"

new_fasta_file = splitext(fasta_file)[0] + '_psuedochromosomes' + splitext(fasta_file)[1]

outhandle = open(new_fasta_file, 'w')

## get an indexed file as a dictionary
dict = SeqIO.index(fasta_file, "fasta")
#spacer = Seq("N" * 200)

##-------------------------------------------------------------------
## 1	Scaffold_6;HRSCAF=123	 18,981,584 	 1,479,199 
##	Scaffold_243849;HRSCAF=245052	 24,228,694 	 7,599,024 
PS1 = SeqRecord(
	dict["Scaffold_6;HRSCAF=123"].seq.reverse_complement() + 
	Seq("N" *  3694098) +
	dict["Scaffold_243849;HRSCAF=245052"].seq.reverse_complement(), 
	id="Chr01",
	description="")
SeqIO.write(PS1,outhandle,"fasta")

##-------------------------------------------------------------------
## 2	Scaffold_222;HRSCAF=581	 43,627,109 	 1,077,892 
PS2 = SeqRecord(
	dict["Scaffold_222;HRSCAF=581"].seq.reverse_complement(),
	id="Chr02",
	description="")
SeqIO.write(PS2,outhandle,"fasta")

##-------------------------------------------------------------------
## 3	Scaffold_243850;HRSCAF=245053	 8,668,524 	 1,034,211 
## 	Scaffold_243841;HRSCAF=244986	 285,174 	 21,326,010 
PS3 = SeqRecord(
	dict["Scaffold_243850;HRSCAF=245053"].seq.reverse_complement() + 
	Seq("N" *  745423) +
	dict["Scaffold_243841;HRSCAF=244986"].seq, 
	id="Chr03",
	description="")
SeqIO.write(PS3,outhandle,"fasta")

##-------------------------------------------------------------------
## 4	Scaffold_132;HRSCAF=439	 1,982,837 	 18,512,855 
## 	Scaffold_243846;HRSCAF=245049	 1,504,333 	 4,861,099 
## 	Scaffold_243846;HRSCAF=245049	 11,069,110 	 10,035,197 
PS4 = SeqRecord(
	dict["Scaffold_132;HRSCAF=439"].seq + 
	Seq("N" *  2018146) +
	dict["Scaffold_243846;HRSCAF=245049"].seq, 
	id="Chr04",
	description="")
SeqIO.write(PS4,outhandle,"fasta")

##-------------------------------------------------------------------
## 5	Scaffold_84;HRSCAF=343	 34,756,670 	 1,102,392 
PS5 = SeqRecord(
	dict["Scaffold_84;HRSCAF=343"].seq.reverse_complement(),
	id="Chr05",
	description="")
SeqIO.write(PS5,outhandle,"fasta")

##-------------------------------------------------------------------
## 6	Scaffold_243835;HRSCAF=244745	 32,902,800 	 1,263,830 
PS6 = SeqRecord(
	dict["Scaffold_243835;HRSCAF=244745"].seq.reverse_complement(),
	id="Chr06",
	description="")
SeqIO.write(PS6,outhandle,"fasta")

##-------------------------------------------------------------------
## 7	Scaffold_243844;HRSCAF=245047	 29,633,337 	 907,698 
PS7 = SeqRecord(
	dict["Scaffold_243844;HRSCAF=245047"].seq.reverse_complement(),
	id="Chr07",
	description="")
SeqIO.write(PS7,outhandle,"fasta")

##-------------------------------------------------------------------
## 8	Scaffold_243845;HRSCAF=245048	 469,962 	 7,020,597 
## 	Scaffold_243837;HRSCAF=244784	 999,746 	 19,687,006 
PS8 = SeqRecord(
	dict["Scaffold_243845;HRSCAF=245048"].seq + 
	Seq("N" *  866588) +
	dict["Scaffold_243837;HRSCAF=244784"].seq, 
	id="Chr08",
	description="")
SeqIO.write(PS8,outhandle,"fasta")

##-------------------------------------------------------------------
## 9	Scaffold_243847;HRSCAF=245050	 529,946 	 33,110,458 
PS9 = SeqRecord(
	dict["Scaffold_243847;HRSCAF=245050"].seq,
	id="Chr09",
	description="")
SeqIO.write(PS9,outhandle,"fasta")

##-------------------------------------------------------------------
## 10	Scaffold_243843;HRSCAF=245046	 7,855,397 	 5,311,299 
PS10 = SeqRecord(
	dict["Scaffold_243843;HRSCAF=245046"].seq.reverse_complement(),
	id="Chr10",
	description="")
SeqIO.write(PS10,outhandle,"fasta")

##-------------------------------------------------------------------
## 11	Scaffold_243848;HRSCAF=245051	 18,409,013 	 571,284 
## 	Scaffold_243852;HRSCAF=245055	 6,100,753 	 1,090,813 
PS11 = SeqRecord(
	dict["Scaffold_243848;HRSCAF=245051"].seq.reverse_complement() + 
	Seq("N" *  200) +
	dict["Scaffold_243852;HRSCAF=245055"].seq.reverse_complement(), 
	id="Chr11",
	description="")
SeqIO.write(PS11,outhandle,"fasta")

##-------------------------------------------------------------------
## 12	Scaffold_243842;HRSCAF=245045	 34,129,778 	 11,547,791 
## 	Scaffold_243842;HRSCAF=245045	 1,393,215 	 3,201,293 
PS12 = SeqRecord(
	dict["Scaffold_243842;HRSCAF=245045"].seq.reverse_complement(),
	id="Chr12",
	description="")
SeqIO.write(PS12,outhandle,"fasta")

##-------------------------------------------------------------------
## 13	Scaffold_243851;HRSCAF=245054	 34,790,909 	 2,468,474 
PS13 = SeqRecord(
	dict["Scaffold_243851;HRSCAF=245054"].seq.reverse_complement(),
	id="Chr13",
	description="")
SeqIO.write(PS13,outhandle,"fasta")

##-------------------------------------------------------------------
## 14	Scaffold_695;HRSCAF=1193	 26,059,148 	 1,584,369 
PS14 = SeqRecord(
	dict["Scaffold_695;HRSCAF=1193"].seq.reverse_complement(),
	id="Chr14",
	description="")
SeqIO.write(PS14,outhandle,"fasta")

##-------------------------------------------------------------------
## 15	Scaffold_243839;HRSCAF=244924	 1,379,616 	 31,241,154 
PS15 = SeqRecord(
	dict["Scaffold_243839;HRSCAF=244924"].seq,
	id="Chr15",
	description="")
SeqIO.write(PS15,outhandle,"fasta")

##-------------------------------------------------------------------
## 16	Scaffold_509;HRSCAF=962	 25,842,861 	 893,334 
PS16 = SeqRecord(
	dict["Scaffold_509;HRSCAF=962"].seq.reverse_complement(),
	id="Chr16",
	description="")
SeqIO.write(PS16,outhandle,"fasta")

##-------------------------------------------------------------------
## 17	Scaffold_122;HRSCAF=423	 815,254 	 30,942,579 
PS17 = SeqRecord(
	dict["Scaffold_122;HRSCAF=423"].seq,
	id="Chr17",
	description="")
SeqIO.write(PS17,outhandle,"fasta")

##-------------------------------------------------------------------
## 18	Scaffold_243836;HRSCAF=244773	 17,087,220 	 795,074 
## 	Scaffold_429;HRSCAF=864	 4,277,033 	 60,186 
PS18 = SeqRecord(
	dict["Scaffold_429;HRSCAF=864"].seq.reverse_complement() +
	Seq("N" *  1619458) +
	dict["Scaffold_243836;HRSCAF=244773"].seq.reverse_complement(),
	id="Chr18",
	description="")
SeqIO.write(PS18,outhandle,"fasta")

##-------------------------------------------------------------------
## 19	Scaffold_19;HRSCAF=176	 356,873 	 25,164,639 
PS19 = SeqRecord(
	dict["Scaffold_19;HRSCAF=176"].seq,
	id="Chr19",
	description="")
SeqIO.write(PS19,outhandle,"fasta")

##-------------------------------------------------------------------
## 20	Scaffold_2;HRSCAF=50	 8,576,120 	 1,317,371 
PS20 = SeqRecord(
	dict["Scaffold_2;HRSCAF=50"].seq.reverse_complement(),
	id="Chr20",
	description="")
SeqIO.write(PS20,outhandle,"fasta")

##-------------------------------------------------------------------
## 21	Scaffold_3668;HRSCAF=4405	 26,789,235 	 6,649,941 
PS21 = SeqRecord(
	dict["Scaffold_3668;HRSCAF=4405"].seq.reverse_complement(),
	id="Chr21",
	description="")
SeqIO.write(PS21,outhandle,"fasta")

##-------------------------------------------------------------------
## 22	Scaffold_2026;HRSCAF=2680	 25,015,752 	 4,474,963 
PS22 = SeqRecord(
	dict["Scaffold_2026;HRSCAF=2680"].seq.reverse_complement(),
	id="Chr22",
	description="")
SeqIO.write(PS22,outhandle,"fasta")

##-------------------------------------------------------------------
## 23	Scaffold_291;HRSCAF=677	 6,159,011 	 1,040,138 
PS23 = SeqRecord(
	dict["Scaffold_291;HRSCAF=677"].seq.reverse_complement(),
	id="Chr23",
	description="")
SeqIO.write(PS23,outhandle,"fasta")


outhandle.close()
