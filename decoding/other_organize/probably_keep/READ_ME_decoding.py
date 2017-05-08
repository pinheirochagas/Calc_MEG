| 'Analyses - Calc_MEG'  
| 'Pinheiro-Chagas - 2016'       
#############################################################################################

| 'Decoding'

| within conditions
	|| classification e regression  
		train op1 test op1
		train op2 test op2
		train pres test pres # with results [3 4 5 6] 
		train cres test cres # with results [3 4 5 6] 
		train presc test presc # with results [3 4 5 6] 
		train presi test presi # with results [3 4 5 6]
	|| classification
		train cres_ires test cres_ires # correct vs. incorrect results
		train add_sub test add_sub
		train add_sub_cmp test add_sub_cmp # need to balance classes here, since cmp has less trials
		train delay_nodelay test delay_nodelay
		train vsa_leftright test vsa_leftright
		train vsa_TL test vsa_TL
		#train vsa_rs test vsa_rs # response side
		#train calc_rs test calc_rs # response side

| across conditions
	|| classification e regression
		train op1 test pres # with results [3 4 5 6] 
		train op1 test cres # with results [3 4 5 6], internally generated
		train op1 test prescdelay 
		train op1 test prescnodelay
		train op1 test presidelay 
		train op1 test presinodelay 
	|| classification
		train vsa_leftright test add_sub
		train add_sub test vsa_leftright
		train op1_34vs56 test add_sub
		train add_sub test op1_34vs56
		#train vsa_rs test calc_rs # response side
		#train calc_rs test vsa_rs # response side
		#train vsa_rs test vsa_leftright 
		#train vsa_leftright test vsa_rs 





| 'ERF'

| 'Time Frequency'

| 'Correlation behavior and decoding/ERF'







