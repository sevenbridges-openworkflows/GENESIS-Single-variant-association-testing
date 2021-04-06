class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-pipelines-dev/sbg-group-segments/14
baseCommand:
- echo
- '"Grouping"'
inputs:
- sbg:category: Inputs
  id: assoc_files
  type: File[]
  label: Assoc files
  doc: Assoc files.
  sbg:fileTypes: RDATA
outputs:
- id: grouped_assoc_files
  type:
  - 'null'
  - type: array
    items:
    - type: array
      items:
      - File
      - 'null'
    - 'null'
  outputBinding:
    outputEval: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.substr(0,chrom_num.lastIndexOf(".")).split('_').slice(0,-1).join('_')
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          var assoc_files_dict = {};
          var grouped_assoc_files = [];
          var chr;
          for(var i=0; i<inputs.assoc_files.length; i++){
              chr = find_chromosome(inputs.assoc_files[i].path)
              if(chr in assoc_files_dict){
                  assoc_files_dict[chr].push(inputs.assoc_files[i])
              }
              else{
                  assoc_files_dict[chr] = [inputs.assoc_files[i]]
              }
          }
          for(var key in assoc_files_dict){
              grouped_assoc_files.push(assoc_files_dict[key])
          }
          return grouped_assoc_files
          
      }
- id: chromosome
  doc: Chromosomes.
  label: Chromosomes
  type: string[]?
  outputBinding:
    outputEval: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.substr(0,chrom_num.lastIndexOf(".")).split('_').slice(0,-1).join('_')
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          var assoc_files_dict = {};
          var output_chromosomes = [];
          var chr;
          for(var i=0; i<inputs.assoc_files.length; i++){
              chr = find_chromosome(inputs.assoc_files[i].path)
              if(chr in assoc_files_dict){
                  assoc_files_dict[chr].push(inputs.assoc_files[i])
              }
              else{
                  assoc_files_dict[chr] = [inputs.assoc_files[i]]
              }
          }
          for(var key in assoc_files_dict){
              output_chromosomes.push(key)
          }
          return output_chromosomes
          
      }
label: SBG Group Segments
requirements:
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571049664
  sbg:revisionNotes:
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571049672
  sbg:revisionNotes: Import
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583406613
  sbg:revisionNotes: find_chromosome function updated
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583493406
  sbg:revisionNotes: find_chromosome function updated2
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583500580
  sbg:revisionNotes: Version 1
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583511231
  sbg:revisionNotes: Corrected for GDS name
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583852790
  sbg:revisionNotes: Revision 1 - Import
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602061140
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606727904
  sbg:revisionNotes: CWLtool preparation
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608561627
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608563954
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608630482
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608630499
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608729995
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608905828
  sbg:revisionNotes: New docker
sbg:image_url:
sbg:projectName: GENESIS pipelines - DEV
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-pipelines-dev/sbg-group-segments/14
sbg:revision: 14
sbg:revisionNotes: New docker
sbg:modifiedOn: 1608905828
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1571049664
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-pipelines-dev
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 14
sbg:publisher: sbg
sbg:content_hash: a515be0f5124c62e65c743e3ca9940a2d4d90f71217b08949ce69537195ad562c
