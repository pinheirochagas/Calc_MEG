Effect-Matched Spatial Filtering (EMSf) MatLab toolbox, readme file.

To install, simply add this folder to your MatLab path.

For comparing two experimental conditions, use ems_2cond_diff.m, e.g.

% (1)
>> [trl,msf] = ems_2cond_diff(DATA,conds,[]);

If you want to use your own custom objective function (or one of the functions
provided, with prefix spf_), use ems_ncond.m, e.g.

% (2)
>> [trl,msf] = ems_ncond(DATA,conds,[],@spf_basic_2cond_diff);

The above is equivalent to 
>> [trl,msf] = ems_2cond_diff(DATA,conds,[]);
since spf_basic_2cond_diff simply takes the difference between two conditions.
However, ems_2cond_diff is optimized for speed.

Use ems_topo_explore to explore the average topography of the spatial filters (msf) 
over temporal windows that you specify by clicking with your mouse on the resulting 
time course, e.g. the difference between two conditions computed on the surrogate 
trials (trl).

Use ems_bootstrap and ems_permute to perform permutation and bootstrap tests on the 
surrogate trials. You must supply a handle to the objective function. If you used 
ems_2cond_diff then use the objective function @spf_basic_2cond_diff.

This code is actively under development and improvement as of January 2014. 
If you have any questions, comments, issues, or bugs please e-mail 
aaron.schurger@gmail.com.
