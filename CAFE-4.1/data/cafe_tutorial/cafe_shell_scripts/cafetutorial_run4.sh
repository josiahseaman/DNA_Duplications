#!cafe
load -i filtered_cafe_input.txt -t 4 -l reports/log_run4.txt
tree ((((cat:68.710507,horse:68.710507):4.566782,cow:73.277289):20.722711,(((((chimp:4.444172,human:4.444172):6.682678,orang:11.126850):2.285855,gibbon:13.412706):7.211527,(macaque:4.567240,baboon:4.567240):16.056992):16.060702,marmos et:36.684935):57.315065):38.738021,(rat:36.302445,mouse:36.302445):96.435575)
lambda -l 0.00265952
genfamily tutorial_genfamily/rnd -t 100
lhtest -d tutorial_genfamily -t ((((3,3)3,3)3,(((((1,1)1,2)2,2)2,(2,2)2)2,3)3)3,(3,3)3) -l 0.00265952 -o reports/lhtest_result.txt
