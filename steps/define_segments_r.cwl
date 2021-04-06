class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/define-segments-r/7
baseCommand: []
inputs:
- sbg:altPrefix: -s
  sbg:toolDefaultValue: '10000'
  sbg:category: Optional parameters
  id: segment_length
  type: int?
  inputBinding:
    prefix: --segment_length
    shellQuote: false
    position: 1
  label: Segment length
  doc: Segment length in kb, used for paralelization.
- sbg:altPrefix: -n
  sbg:category: Optional parameters
  id: n_segments
  type: int?
  inputBinding:
    prefix: --n_segments
    shellQuote: false
    position: 2
  label: Number of segments
  doc: Number of segments, used for paralelization (overrides Segment length). Note
    that this parameter defines the number of segments for the entire genome, so using
    this argument with selected chromosomes may result in fewer segments than you
    expect (and the minimum is one segment per chromosome).
- sbg:toolDefaultValue: hg38
  sbg:category: Configs
  id: genome_build
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
- id: config
  doc: Config file.
  label: Config file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG
- id: define_segments_output
  doc: Segments txt file.
  label: Segments file
  type: File?
  outputBinding:
    glob: segments.txt
  sbg:fileTypes: TXT
label: define_segments.R
arguments:
- prefix: ''
  separate: false
  shellQuote: false
  position: 100
  valueFrom: define_segments.config
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: Rscript /usr/local/analysis_pipeline/R/define_segments.R
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
- class: InitialWorkDirRequirement
  listing:
  - entryname: define_segments.config
    entry: |-
      ${
          var argument = [];
          argument.push('out_file "segments.txt"')
          if(inputs.genome_build){
               argument.push('genome_build "' + inputs.genome_build + '"')
          }
          return argument.join('\n')
      }
    writable: false
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS toolkit - DEMO
sbg:image_url:
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570638123
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573739972
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/1
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593600096
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/2
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593621237
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/3
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060533
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/4
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602065172
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/5
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603798126
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/6
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606727052
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/7
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/define-segments-r/7
sbg:revision: 7
sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/define-segments-r/7
sbg:modifiedOn: 1606727052
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570638123
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:latestRevision: 7
sbg:publisher: sbg
sbg:content_hash: ac91280a285017188ee26cefc0b78bff35fee3b892f03d9368945d0c17a7fae39
sbg:copyOf: boris_majic/genesis-toolkit-dev/define-segments-r/7
