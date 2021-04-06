class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-pipelines-dev/sbg-prepare-segments/14
baseCommand: []
inputs:
- sbg:category: Inputs
  id: input_gds_files
  type: File[]
  label: GDS files
  doc: GDS files.
  sbg:fileTypes: GDS
- sbg:category: Inputs
  id: segments_file
  type: File
  label: Segments file
  doc: Segments file.
  sbg:fileTypes: TXT
- sbg:category: Inputs
  id: aggregate_files
  type: File[]?
  label: Aggregate files
  doc: Aggregate files.
  sbg:fileTypes: RDATA
- sbg:category: Inputs
  id: variant_include_files
  type: File[]?
  label: Variant Include Files
  doc: RData file containing ids of variants to be included.
  sbg:fileTypes: RData
outputs:
- id: gds_output
  doc: GDS files.
  label: GDS files
  type: File[]?
  outputBinding:
    loadContents: true
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }

          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_gdss = [];
          var segments = self[0].contents.split('\n');
          var chr;
          
          segments = segments.slice(1)
          for(var i=0;i<segments.length;i++){
              chr = segments[i].split('\t')[0]
              if(chr in input_gdss){
                  output_gdss.push(input_gdss[chr])
              }
          }
          return output_gdss
      }
  sbg:fileTypes: GDS
- id: segments
  doc: Segments.
  label: Segments
  type: int[]?
  outputBinding:
    loadContents: true
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_segments = []
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          for(var i=0;i<segments.length;i++){
              chr = segments[i].split('\t')[0]
              if(chr in input_gdss){
                  output_segments.push(i+1)
              }
          }
          return output_segments
          
      }
- id: aggregate_output
  doc: Aggregate output.
  label: Aggregate output
  type:
  - 'null'
  - type: array
    items:
    - 'null'
    - File
  outputBinding:
    loadContents: true
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          function pair_chromosome_gds_special(file_array, agg_file){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = agg_file
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          if(inputs.aggregate_files){
              if (inputs.aggregate_files[0] != null){
                  if (inputs.aggregate_files[0].basename.includes('chr'))
                      var input_aggregate_files = pair_chromosome_gds(inputs.aggregate_files);
                  else
                      var input_aggregate_files = pair_chromosome_gds_special(inputs.input_gds_files, inputs.aggregate_files[0].path);
                  var output_aggregate_files = []
                  for(var i=0;i<segments.length;i++){
                      chr = segments[i].split('\t')[0]
                      if(chr in input_aggregate_files){
                          output_aggregate_files.push(input_aggregate_files[chr])
                      }
                      else if(chr in input_gdss){
                          output_aggregate_files.push(null)
                      }
                  }
                  return output_aggregate_files
              }
          }
          else{
              var null_outputs = []
              for(var i=0; i<segments.length; i++){
                  chr = segments[i].split('\t')[0]
                  if(chr in input_gdss){
                      null_outputs.push(null)
                  }
              }
              return null_outputs
          }
      }
- id: variant_include_output
  doc: Variant Include Output
  label: Variant Include Output
  type:
  - 'null'
  - type: array
    items:
    - 'null'
    - File
  outputBinding:
    loadContents: true
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          if(inputs.variant_include_files){
              if (inputs.variant_include_files[0] != null){
                  var input_variant_files = pair_chromosome_gds(inputs.variant_include_files)
                  var output_variant_files = []
                  for(var i=0;i<segments.length;i++){
                      chr = segments[i].split('\t')[0]
                      if(chr in input_variant_files){
                          output_variant_files.push(input_variant_files[chr])
                      }
                      else if(chr in input_gdss){
                          output_variant_files.push(null)
                      }
                  }
                  return output_variant_files
              }
          }
          else{
              var null_outputs = [];
              for(var i=0; i<segments.length; i++){
                  chr = segments[i].split('\t')[0]
                  if(chr in input_gdss){
                      null_outputs.push(null)
                  }
              }
              return null_outputs
          }
      }
label: SBG Prepare Segments
arguments:
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: |-
    ${
        return "cp " + inputs.segments_file.path + " ."
    }
requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571048402
  sbg:revisionNotes:
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571048422
  sbg:revisionNotes: Import
- sbg:revision: 2
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1574267860
  sbg:revisionNotes: Create special case when single multichromosomal aggregate file
    is provided
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583155192
  sbg:revisionNotes: Var added in variable initialisation step
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583158233
  sbg:revisionNotes: find_chromosome changed to support *_chrXX_merged.gds
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602061171
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608289003
  sbg:revisionNotes: Pajce 1
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608296924
  sbg:revisionNotes: pajce 2
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608562054
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608562705
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608567888
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608568045
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608729624
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608729837
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608905868
  sbg:revisionNotes: New docker
sbg:projectName: GENESIS pipelines - DEV
sbg:image_url:
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-pipelines-dev/sbg-prepare-segments/14
sbg:revision: 14
sbg:revisionNotes: New docker
sbg:modifiedOn: 1608905868
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1571048402
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-pipelines-dev
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 14
sbg:publisher: sbg
sbg:content_hash: af5431cfdc789d53445974b82b534a1ba1c6df2ac79d7b39af88dce65def8cb34
