class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/assoc-single-r/13
baseCommand: []
inputs:
- sbg:category: Configs
  id: gds_file
  type: File
  label: GDS file
  doc: GDS file.
  sbg:fileTypes: GDS
- sbg:category: Configs
  id: null_model_file
  type: File
  label: Null model file
  doc: Null model file.
  sbg:fileTypes: RDATA
- sbg:category: Configs
  id: phenotype_file
  type: File
  label: Phenotype file
  doc: RData file with AnnotatedDataFrame of phenotypes.
  sbg:fileTypes: RDATA
- sbg:toolDefaultValue: '5'
  sbg:category: Configs
  id: mac_threshold
  type: float?
  label: MAC threshold
  doc: 'Minimum minor allele count for variants to include in test. Use a higher threshold
    when outcome is binary. To disable it set it to NA. Tool default: 5.'
- sbg:toolDefaultValue: '0.001'
  sbg:category: Configs
  id: maf_threshold
  type: float?
  label: MAF threshold
  doc: 'Minimum minor allele frequency for variants to include in test. Only used
    if MAC threshold is NA. Tool default: 0.001.'
- sbg:toolDefaultValue: 'TRUE'
  sbg:category: Configs
  id: pass_only
  type:
  - 'null'
  - type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
    name: pass_only
  label: Pass only
  doc: TRUE to select only variants with FILTER=PASS.
- sbg:category: Configs
  id: segment_file
  type: File?
  label: Segment file
  doc: Segment file.
  sbg:fileTypes: TXT
- sbg:toolDefaultValue: score
  sbg:category: Configs
  id: test_type
  type:
  - 'null'
  - type: enum
    symbols:
    - score
    - score.spa
    name: test_type
  label: Test type
  doc: 'Type of test to perform. If samples are related (mixed model), options are
    score if binary is FALSE, score and score.spa if binary is TRUE. Default value:
    score.'
- sbg:category: Configs
  id: variant_include_file
  type: File?
  label: Variant include file
  doc: RData file with vector of variant.id to include.
  sbg:fileTypes: RDATA
- sbg:altPrefix: -c
  sbg:category: Optional inputs
  id: chromosome
  type: string?
  inputBinding:
    prefix: --chromosome
    shellQuote: false
    position: 1
  label: Chromosome
  doc: Chromosome (1-24 or X,Y).
- sbg:category: Optional parameters
  id: segment
  type: int?
  inputBinding:
    prefix: --segment
    shellQuote: false
    position: 2
  label: Segment number
  doc: Segment number.
- sbg:category: Input options
  sbg:toolDefaultValue: '8'
  id: memory_gb
  type: float?
  label: memory GB
  doc: 'Memory in GB per job. Default value: 8.'
- sbg:category: Input options
  sbg:toolDefaultValue: '1'
  id: cpu
  type: int?
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
- sbg:category: General
  sbg:toolDefaultValue: '1024'
  id: variant_block_size
  type: int?
  label: Variant block size
  doc: 'Number of variants to read in a single block. Default: 1024'
- sbg:toolDefaultValue: assoc_single
  id: out_prefix
  type: string?
  label: Output prefix
  doc: Output prefix
- id: genome_build
  type:
  - 'null'
  - type: enum
    symbols:
    - hg19
    - hg38
    name: genome_build
  label: Genome build
  doc: Genome build for the genotypes in the GDS file (hg19 or hg38). Used to divide
    the genome into segments for parallel processing.
  default: hg38
outputs:
- id: configs
  doc: Config files.
  label: Config files
  type: File[]?
  outputBinding:
    glob: '*config*'
  sbg:fileTypes: CONFIG
- id: assoc_single
  doc: Assoc single output.
  label: Assoc single output
  type: File?
  outputBinding:
    glob: '*.RData'
    outputEval: $(inheritMetadata(self, inputs.gds_file))
  sbg:fileTypes: RDATA
label: assoc_single.R
arguments:
- prefix: ''
  separate: false
  shellQuote: false
  position: 100
  valueFrom: |-
    ${
        if(inputs.is_unrel)
        {
            return "assoc_single_unrel.config"
        }
        else
        {
            return "assoc_single.config"
        }
        
    }
- prefix: ''
  shellQuote: false
  position: 1
  valueFrom: |-
    ${
        if(inputs.is_unrel)
        {
            return "Rscript /usr/local/analysis_pipeline/R/assoc_single_unrel.R"
        }
        else
        {
            return "Rscript /usr/local/analysis_pipeline/R/assoc_single.R"
        }
        
    }
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: |-
    ${
        if (inputs.cpu)
            return 'export NSLOTS=' + inputs.cpu + ' &&'
        else
            return ''
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
            return parseFloat(inputs.memory_gb * 1024)
        else
            return 8*1024
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
  - entryname: assoc_single.config
    entry: |-
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
              
          var chr = find_chromosome(inputs.gds_file.path)
          
          var argument = [];
          if(!inputs.is_unrel)
          {   
              if(inputs.out_prefix){
                  argument.push("out_prefix \"" + inputs.out_prefix + "_chr"+chr + "\"");
              }
              if(!inputs.out_prefix){
              var data_prefix = inputs.gds_file.basename.split('chr');
              var data_prefix2 = inputs.gds_file.basename.split('.chr');
              if(data_prefix.length == data_prefix2.length)
                  argument.push('out_prefix "' + data_prefix2[0] + '_single_chr' + chr + inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0] +'"');
              else
                  argument.push('out_prefix "' + data_prefix[0] + 'single_chr' + chr +inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0]+'"');}
              argument.push('gds_file "' + inputs.gds_file.path +'"');
              argument.push('null_model_file "' + inputs.null_model_file.path + '"');
              argument.push('phenotype_file "' + inputs.phenotype_file.path + '"');
              if(inputs.mac_threshold){
                  argument.push('mac_threshold ' + inputs.mac_threshold);
              }
              if(inputs.maf_threshold){
                  argument.push('maf_threshold ' + inputs.maf_threshold);
              }
              if(inputs.pass_only){
                  argument.push('pass_only ' + inputs.pass_only);
              }
              if(inputs.segment_file){
                  argument.push('segment_file "' + inputs.segment_file.path + '"');
              }
              if(inputs.test_type){
                  argument.push('test_type "' + inputs.test_type + '"') ;
              }
              if(inputs.variant_include_file){
                  argument.push('variant_include_file "' + inputs.variant_include_file.path + '"');
              }
              if(inputs.variant_block_size){
                  argument.push('variant_block_size ' + inputs.variant_block_size);
              }
              if(inputs.genome_build){
                  argument.push('genome_build ' + inputs.genome_build);
              }
              
              argument.push('');
              return argument.join('\n');
          }
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
- class: sbg:AWSInstanceType
  value: r4.8xlarge;ebs-gp2;500
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS toolkit - DEMO
sbg:image_url:
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570638138
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573666773
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/3
- sbg:revision: 2
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573741169
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/4
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583489622
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/5
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584009500
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/6
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593600081
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/7
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593621247
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/8
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060522
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/9
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602065185
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/10
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603361950
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/11
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603462909
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/12
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603720328
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/13
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606727334
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/assoc-single-r/14
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608561527
  sbg:revisionNotes: ''
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/assoc-single-r/13
sbg:revision: 13
sbg:revisionNotes: ''
sbg:modifiedOn: 1608561527
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570638138
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 13
sbg:publisher: sbg
sbg:content_hash: adb75c4bae3b12cf223c69a1fa5b7b78686dc0ea3b11a56d7d4c89f8fd61fa2c7
