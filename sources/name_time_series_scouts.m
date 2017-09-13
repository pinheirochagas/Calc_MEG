InitDirsMEGcalc
source_result_dir = [data_root_dir 'results/sources/'];

roi.sub.op2_0 = sub1
roi.sub.op2_1 = sub2
roi.sub.op2_2 = sub3
roi.sub.op2_3 = sub4

roi.add.op2_0 = add1
roi.add.op2_1 = add2
roi.add.op2_2 = add3
roi.add.op2_3 = add4

roi.addsub.op2_0 = addsub1
roi.addsub.op2_1 = addsub2
roi.addsub.op2_2 = addsub3
roi.addsub.op2_3 = addsub4

save([source_result_dir 'scouts_ts_add_sub_addsub_op2.mat'], 'roi')

save([source_result_dir 'scouts_ts_addsub_all.mat'], 'addsub_all')

