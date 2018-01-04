## Program:  Combine_RIBS_EDDs_v2.R
## Purpose: Combnines RIBS EDD files ("sample" and "result" files) and adds column headers.
## Author: Gavin Lemley, Alene Onion
## Created Fall 2017 (split from RIBS_QA_checks_v4.R)
## Last updated: 1/4/2018

##### NOTE: BE SURE TO CLEAR WORKSPACE BEFORE RUNNING #####

## Instructions: Target directory must contain folders named as EDD numbers, which each contain their respective EDD contents.
##                Change input (x2) and output directories as needed.

####### Change input directory here and in 2nd line of "for" loop below #########
setwd("C:/Rscripts/RIBS.Data/data/2017_Wallkill")

folder_list <- list.files()
nfolder_list = length(folder_list)

for (i in 1:nfolder_list){
  setwd(paste("C:/Rscripts/RIBS.Data/data/2017_Wallkill/",folder_list[i],sep=""))
  if(!exists("result")){
    # print(paste0("loop1: ", folder_list[i],"\n")) #for testing loop
    
    result <- read.table("TestResultQC_v3.txt",sep=",",fill=TRUE,header=FALSE,stringsAsFactors=FALSE,
                         col.names = c("sys_sample_code","lab_anl_method_name","analysis_date","fraction","column_number","test_type","lab_matrix_code","analysis_location","basis","container_id","dilution_factor","prep_method","prep_date","leachate_method","leachate_date","lab_name_code","qc_level","lab_sample_id","percent_moisture","subsample_amount","subsample_amount_unit","analyst_name","instrument_id","comment","preservative","final_volume","final_volume_unit","cas_rn","chemical_name","result_value","result_error_delta","result_type_code","reportable_result","detect_flag","lab_qualifiers","validator_qualifiers","interpreted_qualifiers","validated_yn","method_detection_limit","reporting_detection_limit","quantitation_limit","result_unit","detection_limit_unit","tic_retention_time","minimum_detectable_conc","counting_error","uncertainty","critical_value","validation_level","result_comment","qc_original_conc","qc_spike_added","qc_spike_measured","qc_spike_recovery","qc_dup_original_conc","qc_dup_spike_added","qc_dup_spike_measured","qc_dup_spike_recovery","qc_rpd","qc_spike_lcl","qc_spike_ucl","qc_rpd_cl","qc_spike_status","qc_dup_spike_status","qc_rpd_status","lab_sdg"))
    sample <- read.table("Sample_v3.txt",sep=",",fill=TRUE,header=FALSE, stringsAsFactors=FALSE,
                         col.names = c("#data_provider","sys_sample_code","sample_name","sample_matrix_code","sample_type_code","sample_source","parent_sample_code","sample_delivery_group","sample_date","sys_loc_code","start_depth","end_depth","depth_unit","chain_of_custody","sent_to_lab_date","sample_receipt_date","sampler","sampling_company_code","sampling_reason","sampling_technique","task_code","collection_quarter","composite_yn","composite_desc","sample_class","custom_field_1","custom_field_2","custom_field_3","comment"))
  }
  else if(exists("result")){
    # print(paste0("loop2: ", folder_list[i],"\n")) #for testing loop
    
    result_temp <- read.table("TestResultQC_v3.txt",sep=",",fill=TRUE,header=FALSE,stringsAsFactors=FALSE,
                              col.names = c("sys_sample_code","lab_anl_method_name","analysis_date","fraction","column_number","test_type","lab_matrix_code","analysis_location","basis","container_id","dilution_factor","prep_method","prep_date","leachate_method","leachate_date","lab_name_code","qc_level","lab_sample_id","percent_moisture","subsample_amount","subsample_amount_unit","analyst_name","instrument_id","comment","preservative","final_volume","final_volume_unit","cas_rn","chemical_name","result_value","result_error_delta","result_type_code","reportable_result","detect_flag","lab_qualifiers","validator_qualifiers","interpreted_qualifiers","validated_yn","method_detection_limit","reporting_detection_limit","quantitation_limit","result_unit","detection_limit_unit","tic_retention_time","minimum_detectable_conc","counting_error","uncertainty","critical_value","validation_level","result_comment","qc_original_conc","qc_spike_added","qc_spike_measured","qc_spike_recovery","qc_dup_original_conc","qc_dup_spike_added","qc_dup_spike_measured","qc_dup_spike_recovery","qc_rpd","qc_spike_lcl","qc_spike_ucl","qc_rpd_cl","qc_spike_status","qc_dup_spike_status","qc_rpd_status","lab_sdg"))
    sample_temp <- read.table("Sample_v3.txt",sep=",",fill=TRUE,header=FALSE,stringsAsFactors=FALSE,
                              col.names = c("#data_provider","sys_sample_code","sample_name","sample_matrix_code","sample_type_code","sample_source","parent_sample_code","sample_delivery_group","sample_date","sys_loc_code","start_depth","end_depth","depth_unit","chain_of_custody","sent_to_lab_date","sample_receipt_date","sampler","sampling_company_code","sampling_reason","sampling_technique","task_code","collection_quarter","composite_yn","composite_desc","sample_class","custom_field_1","custom_field_2","custom_field_3","comment"))
    result <- rbind(result, result_temp)
    sample <- rbind(sample,sample_temp)
  }
}

RIBS_input <- merge(result,sample,by="sys_sample_code", all=TRUE)

####### Change output directory as needed #########
setwd("C:/Rscripts/RIBS.Data/output")

write.table(RIBS_input, file="RIBS_EDD_aggregate.csv",sep=",", row.names = FALSE)




