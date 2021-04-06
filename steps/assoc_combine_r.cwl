class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/assoc-combine-r/14
baseCommand: []
inputs:
- sbg:altPrefix: -c
  sbg:category: Optional inputs
  id: chromosome
  type: string[]?
  inputBinding:
    prefix: --chromosome
    shellQuote: false
    position: 10
  label: Chromosome
  doc: Chromosome (1-24 or X,Y).
- id: assoc_type
  type:
    type: enum
    symbols:
    - single
    - aggregate
    - window
    name: assoc_type
  label: Association Type
  doc: 'Type of association test: single, window or aggregate.'
- id: assoc_files
  type: File[]
  label: Association files
  doc: Association files to be combined.
  sbg:fileTypes: RDATA
- id: out_prefix
  type: string?
  label: Out Prefix
  doc: Output prefix.
- sbg:category: Input options
  sbg:toolDefaultValue: '4'
  id: memory_gb
  type: float?
  label: memory GB
  doc: 'Memory in GB per one job. Default value: 4GB.'
- sbg:category: Input Options
  sbg:toolDefaultValue: '1'
  id: cpu
  type: int?
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
- sbg:category: General
  id: conditional_variant_file
  type: File?
  label: Conditional variant file
  doc: RData file with data frame of of conditional variants. Columns should include
    chromosome (or chr) and variant.id. The alternate allele dosage of these variants
    will be included as covariates in the analysis.
  sbg:fileTypes: RData, RDATA
outputs:
- id: assoc_combined
  doc: Assoc combined.
  label: Assoc combined
  type: File?
  outputBinding:
    glob: |-
      ${
          
          //var input_files = [].concat(inputs.assoc_files);
          //var first_filename = input_files[0].basename;
          
          //var chr = first_filename.split('_chr')[1].split('_')[0].split('.RData')[0];
          
          //return first_filename.split('chr')[0]+'chr'+chr+'.RData';
          
          return '*.RData'
      }
    outputEval: $(inheritMetadata(self, inputs.assoc_files))
  sbg:fileTypes: RDATA
- id: configs
  doc: Config files.
  label: Config files
  type: File[]?
  outputBinding:
    glob: '*config*'
  sbg:fileTypes: CONFIG
label: assoc_combine.R
arguments:
- prefix: ''
  shellQuote: false
  position: 100
  valueFrom: assoc_combine.config
- prefix: ''
  shellQuote: false
  position: 5
  valueFrom: Rscript /usr/local/analysis_pipeline/R/assoc_combine.R
- prefix: ''
  shellQuote: false
  position: 1
  valueFrom: |-
    ${
        var command = '';
        var i;
        for(i=0; i<inputs.assoc_files.length; i++)
            command += "ln -s " + inputs.assoc_files[i].path + " " + inputs.assoc_files[i].path.split("/").pop() + " && "
        
        return command
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
- class: ResourceRequirement
  ramMin: |-
    ${
        if(inputs.memory_gb)
            return parseInt(inputs.memory_gb * 1024)
        else
            return 4*1024
    }
  coresMin: |-
    ${ if(inputs.cpu)
            return inputs.cpu 
        else 
            return 1
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: assoc_combine.config
    entry: |-
      ${
          var argument = [];
          argument.push('assoc_type "'+ inputs.assoc_type + '"');
          var data_prefix = inputs.assoc_files[0].basename.split('_chr')[0];
          if (inputs.out_prefix)
          {
              argument.push('out_prefix "' + inputs.out_prefix+ '"');
          }
          else
          {
              argument.push('out_prefix "' + data_prefix+ '"');
          }
          
          if(inputs.conditional_variant_file){
              argument.push('conditional_variant_file "' + inputs.conditional_variant_file.path + '"');
          }
          //if(inputs.assoc_files)
          //{
          //    arguments.push('assoc_files "' + inputs.assoc_files[0].path + '"')
          //}
          return argument.join('\n') + '\n'
      }
    writable: false
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS toolkit - DEMO
sbg:image_url:
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570638129
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573739976
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/1
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583403361
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/2
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583500657
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/3
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583504951
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/4
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583507194
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/5
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583774238
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/6
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583870141
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/7
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593600086
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/8
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593621244
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/9
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060526
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/10
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602065180
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/11
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603722208
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/12
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606728652
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/13
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608570708
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/14
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/assoc-combine-r/14
sbg:revision: 14
sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-combine-r/14
sbg:modifiedOn: 1608570708
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570638129
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 14
sbg:publisher: sbg
sbg:content_hash: af0bb74ff0be18115520a67d15107d6f1f0767775b6cd62f7a9c39fa0eb8f12da
sbg:copyOf: boris_majic/genesis-toolkit-dev/assoc-combine-r/14
