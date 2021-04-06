class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/sbg-gds-renamer/6
baseCommand:
- cp
inputs:
- id: in_variants
  type: File
  label: GDS input
  doc: "This tool removes suffix after 'chr##' in GDS filename. ## stands for chromosome\
    \ name and can be (1-22,X,Y)."
  sbg:fileTypes: GDS
outputs:
- id: renamed_variants
  doc: Renamed GDS file.
  label: Renamed GDS
  type: File
  outputBinding:
    glob: |-
      ${
          return '*'+inputs.in_variants.nameext
      }
  sbg:fileTypes: GDS
doc: |-
  This tool renames GDS file in GENESIS pipelines if they contain suffixes after chromosome (chr##) in the filename.
  For example: If GDS file has name data_chr1_subset.gds the tool will rename GDS file to data_chr1.gds.
label: SBG GDS renamer
arguments:
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: |-
    ${
        if(inputs.in_variants){
        return inputs.in_variants.path}
    }
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: |-
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
        
        var chr = find_chromosome(inputs.in_variants.nameroot)
        var base = inputs.in_variants.nameroot.split('chr'+chr)[0]
        
        return base+'chr' + chr + inputs.in_variants.nameext
      
    }
- prefix: ''
  shellQuote: false
  position: 100
  valueFrom: |-
    ${
        return ' >> job.out.log'   
    }
requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS toolkit - DEMO
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584028650
  sbg:revisionNotes:
- sbg:revision: 1
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584028709
  sbg:revisionNotes: ''
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584359096
  sbg:revisionNotes: Description updated
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602061103
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602065019
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608297151
  sbg:revisionNotes: cp instead of mv due to cwltool compatibility
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608905957
  sbg:revisionNotes: New docker
sbg:image_url:
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/sbg-gds-renamer/6
sbg:revision: 6
sbg:revisionNotes: New docker
sbg:modifiedOn: 1608905957
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1584028650
sbg:createdBy: dajana_panovic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
sbg:latestRevision: 6
sbg:publisher: sbg
sbg:content_hash: ab721cbd39c33d272c5c42693fb02e02e43d95a3f421f40615cbf79ed023c35cc
