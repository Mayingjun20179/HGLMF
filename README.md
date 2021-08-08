# HGLMF
Hypergraph-based Logistic Matrix Factorization for Metabolite-disease Interaction Prediction

Data:
 Met_dis_2020. mat: Total data file, Matlab mat format file
 Disease:
  Met_dis_2020. dis_inf: Information about the disease
  Met_dis_2020. dis_inf.dis_id: Mesh ID and disease name of the disease
  Met_dis_2020. dis_inf. Dis_gosim: similarity of GO function of disease
  Met_dis_2020. dis_inf.dis_treesim: Semantic similarity of disease
 Metabolite:
  Met_dis_2020. met_inf: Metabolite information
  Met_dis_2020. met_inf.met_id: The ID of the metabolite (ID in HMDB), the name of the 
  Met_dis_2020. met_inf. Met_simle_sim: Tanimoto similarity of metabolites
  Met_dis_2020. met_inf. met_gen_go_sim: Genetic functional similarity of metabolites
 Interaction:
  Met_dis_2020. Inter: The interaction of metabolites and disease.


Code:
 HGLMF: The folder where the code for the HGLMF method is stored.
 GRNMF: Folder containing the code for the GRNMF methods
 MDBIRW: The folder that stores the code associated with the MDBIRW method
 MN-LMF: The folder where the code for the MN-LMF method is stored
 GRGMF: A folder that stores code related to GRGMF methods
 WMANRWR: Folder containing code related to the WMANRWR method
