# uav_trajectory_coverage - revise branch

**Yuxuan Fang**

08/03/2023

This is the reformulated version based on Billy's work, placed in the `original` folder. The `OSM_2_Formatted.mlx` generates dependent formatted data for `main.mlx`. And `main.mlx` provides visualizations.

There's an unresolved bug (serialization error) in the `main.mlx`. I propose the reason is the high volume of reading/writing to the RAM. Still, a figure will be generated.

The `main.mlx` can be more compacted. You can try it if you like!

**Note:** You can test the codes with datasets. However, the dataset is rather extensive, so I put the dataset paths into `.gitignore`.
If you have datasets folders like `FormattedDatasets` and `OSM_datasets`, please put them in the `datasets` folder. Make sure the `datasets` locates at the same level as the `original` folder.
