dct:creator:
  "@id": "sbg"
  foaf:name: SevenBridges
  foaf:mbox: "mailto:support@sbgenomics.com"
$namespaces:
  sbg: https://sevenbridges.com
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

class: Workflow
cwlVersion: v1.1
doc: |-
  **Single Variant workflow** runs single-variant association tests. It consists of several steps. Define Segments divides genome into segments, either by a number of segments, or by a segment length. Note that number of segments refers to whole genome, not a number of segments per chromosome. Association test is then performed for each segment in parallel, before combining results on chromosome level. Final step produces QQ and Manhattan plots.

  This workflow uses the output from a model fit using the null model workflow to perform score tests for all variants individually. The reported effect estimate is for the alternate allele, and multiple alternate alleles for a single variant are tested separately.

  When testing a binary outcome, the saddlepoint approximation (SPA) for p-values [1][2] can be used by specifying **Test type** = ‘score.spa’; this is generally recommended. SPA will provide better calibrated p-values, particularly for rarer variants in samples with case-control imbalance. 

  If your genotype data has sporadic missing values, they are mean imputed using the allele frequency observed in the sample.

  On the X chromosome, males have genotype values coded as 0/2 (females as 0/1/2).

  This workflow utilizes the *assocTestSingle* function from the GENESIS software [3].

  ### Common Use Cases

  Single Variant Association Testing workflow is designed to run single-variant association tests using GENESIS software. Set of variants on which to run association testing can be reduced by providing **Variant Include Files** - One file per chromosome containing variant IDs for variants on which association testing will be performed.


  ### Common issues and important notes
  * Association Testing - Single job can be very memory demanding, depending on number of samples and null model used. We suggest running with at least 5GB of memory allocated for small studies, and to use approximation of 0.5GB per thousand samples for larger studies (with more than 10k samples), but this again depends on complexity of null model. If a run fails with *error 137*, and with message killed, most likely cause is lack of memory. Memory can be allocated using the **memory GB** parameter.

  * This workflow expects **GDS** files split by chromosome, and will not work otherwise. If provided, **variant include** files must also be split in the same way. Also GDS and Variant include files should be properly named. It is expected that chromosome is included in the filename in following format: chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename. Examples for GDS: data_subset_chr1.gds, data_chr1_subset.gds. Examples for Variant include files: variant_include_chr1.RData, chr1_variant_include.RData.

  * Some input arguments are mutually exclusive, for more information, please visit workflow [github page](https://github.com/UW-GAC/analysis_pipeline/tree/v2.5.0)

  ### Changes introduced by Seven Bridges
  There are no changes introduced by Seven Bridges.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. 
          

  | Samples &nbsp; &nbsp; |    | Rel. Matrix &nbsp; &nbsp;|Parallel instances &nbsp; &nbsp; | Instance type  &nbsp; &nbsp; &nbsp; &nbsp;| Spot/On Dem. &nbsp; &nbsp; |CPU &nbsp; &nbsp; | RAM &nbsp; &nbsp; | Time  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| Cost |
  |--------------------|---------------|----------------|------------------------|--------------------|--------------------|--------|--------|---------|-------|
  | 2.5k   |                 |   w/o          | 8                           |  r4.8xlarge | Spot     |1  | 2   | 1 h, 8 min   | $5  |
  | 2.5k   |               |   Dense     | 8                           |  r4.8xlarge | Spot     |1  | 2   | 1 h, 8 min   | $5  |
  | 10k   |                 |   w/o           | 8                           |  c5.18xlarge | On Demand     |1  | 2   | 50 min   | $10  |
  | 10k   |                |   Sparse     | 8                           |  c5.18xlarge | On Demand     |1  | 2   | 58 min   | $11  |
  | 10k   |                |   Sparse     | 8                           |  r4.8xlarge | On Demand     |1  | 2   | 1 h, 30 min   | $11  |
  | 10k   |                 |   Dense      | 8                           |  r5.4xlarge | On Demand     |1  | 8   | 3 h   | $24  |
  | 36k  |                  |   w/o           | 8                           |  r5.4xlarge | On Demand     |1  | 5   | 3 h, 20 min   | $27  |
  | 36k  |                  |   Sparse     | 8                           |  r5.4xlarge | On Demand     |1  | 5   | 4 h   | $32  |
  | 36k   |                  |   Sparse     | 8                           |  r5.12xlarge | On Demand     |1  | 5   | 1 h, 20 min   | $32  |
  | 36k   |                  |   Dense      | 8                           |  r5.12xlarge | On Demand     |1  | 50   | 1 d, 15 h   | $930  |
  | 36k   |                 |   Dense      | 8                           |  r5.24xlarge | On Demand     |1  | 50   | 17 h   | $800  |
  | 50k   |                  |   w/o           | 8                           |  r5.12xlarge | On Demand     |1  | 8   | 2 h   | $44  |
  | 50k   |                  |   Sparse     | 8                           |  r5.12xlarge | On Demand     |1  | 8   | 2 h   | $48 |
  | 50k   |                  |   Dense      | 8                           |  r5.24xlarge | On Demand     |48  | 100   | 11 d   | $13500  |
  | 2.5k   |                  |   w/o          | 8                           |  n1-standard-64 | Preemptible    |1  | 2   | 1 h   | $7  |
  | 2.5k   |                  |   Dense     | 8                           |  n1-standard-64 | Preemptible    |1  | 2   | 1 h   | $7  |
  | 10k   |                  |   w/o           | 8                           |  n1-standard-4 | On Demand     |1  | 2   | 1 h, 12 min  | $13  |
  | 10k   |                  |   Sparse     | 8                           |  n1-standard-4 | On Demand     |1  | 2   | 1 h, 13  min   | $14 |
  | 10k  |                  |   Dense      | 8                           |  n1-highmem-32 | On Demand     |1  | 8   | 2 h, 20  min   | $30  |
  | 36k   |                  |   w/o           | 8                           |  n1-standard-64 | On Demand     |1  | 5   | 1 h, 30  min   | $35  |
  | 36k   |                 |   Sparse     | 8                           |  n1-highmem-16 | On Demand     |1  | 5   | 4 h, 30  min   | $35  |
  | 36k   |                  |   Sparse     | 8                           |  n1-standard-64 | On Demand     |1  | 5   | 1 h, 30  min   | $35  |
  | 36k   |                  |   Dense      | 8                           |  n1-highmem-96 | On Demand     |1  | 50   | 1 d, 6  h   | $1300  |
  | 50k   |                  |   w/o           | 8                           |  n1-standard-96 | On Demand     |1  | 8    | 2  h   | $73  |
  | 50k   |                  |   Sparse     | 8                           |  n1-standard-96 | On Demand     |1  | 8    | 2  h   | $73  |
  | 50k   |                  |   Dense      | 8                           |  n1-highmem-96 | On Demand     |16  | 100    | 6  d   | $6600  |

  In tests performed we used 1000G (tasks with 2.5k participants) and TOPMed freeze5 datasets (tasks with 10k or more participants). 
  All these tests are done with applied **MAF >= 1%** filter. The number of variants that have been tested is **14 mio in 1000G** and **12 mio in TOPMed freeze 5** dataset. 

  Also, a common filter in these analysis is **MAC>=5**. In that case the number of variants would be **32 mio for 1000G** and **92 mio for TOPMed freeze5** data. Since for single variant testing, the compute time grows linearly with the number of variants tested the execution time and price can be easily estimated from the results above.

  *For more details on **spot/preemptible instances** please visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances).*   


  ### API Python Implementation

  The app's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for the corresponding Platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).

  ```python
  from sevenbridges import Api

  authentication_token, api_endpoint = "enter_your_token", "enter_api_endpoint"
  api = Api(token=authentication_token, url=api_endpoint)
  # Get project_id/app_id from your address bar. Example: https://f4c.sbgenomics.com/u/your_username/project/app
  project_id, app_id = "your_username/project", "your_username/project/app"
  # Get file names from files in your project. Example: Names are taken from Data/Public Reference Files.
  inputs = {
      "input_gds_files": api.files.query(project=project_id, names=["basename_chr1.gds", "basename_chr2.gds", ..]),
      "phenotype_file": api.files.query(project=project_id, names=["name_of_phenotype_file"])[0],
      "null_model_file": api.files.query(project=project_id, names=["name_of_null_model_file"])[0]
  }
  task = api.tasks.create(name='Single Variant Association Testing - API Run', project=project_id, app=app_id, inputs=inputs, run=False)
  ```
  Instructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).

  Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).


  ### References
  [1] [SaddlePoint Approximation (SPA)](https://doi.org/10.1016/j.ajhg.2017.05.014)  
  [2] [SPA - additional reference](https://doi.org/10.1038/s41588-018-0184-y)  
  [3] [GENESIS toolkit](doi.org/10.1093/bioinformatics/btz567)
label: Single Variant Association Testing
$namespaces:
  sbg: https://sevenbridges.com
inputs:
- id: segment_length
  type: int?
  label: Segment length
  doc: Segment length in kb, used for parallelization.
  sbg:toolDefaultValue: 10000kb
  sbg:x: -461
  sbg:y: -193
- id: n_segments
  type: int?
  label: Number of segments
  doc: Number of segments, used for parallelization (overrides Segment length). Note
    that this parameter defines the number of segments for the entire genome, so using
    this argument with selected chromosomes may result in fewer segments than you
    expect (and the minimum is one segment per chromosome).
  sbg:x: -404.39886474609375
  sbg:y: -73.05772399902344
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
  sbg:toolDefaultValue: hg38
  sbg:x: -461
  sbg:y: 58
- id: variant_include_files
  sbg:fileTypes: RDATA
  type: File[]?
  label: Variant Include Files
  doc: RData file(s) with a vector of variant.id to include. Files may be separated
    by chromosome with ‘chr##’ string corresponding to each GDS file. If not provided,
    all variants in the GDS file will be included in the analysis.
  sbg:x: -38.86707305908203
  sbg:y: -384.265869140625
- id: phenotype_file
  sbg:fileTypes: RDATA
  type: File
  label: Phenotype file
  doc: RData file with an AnnotatedDataFrame of phenotypes and covariates. Sample
    identifiers must be in column named “sample.id”. It is recommended to use the
    phenotype file output by the GENESIS Null Model app.
  sbg:x: -8.571429252624512
  sbg:y: 236.42857360839844
- id: pass_only
  type:
  - 'null'
  - type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
    name: pass_only
  label: Pass only
  doc: TRUE to select only variants with FILTER=PASS. If FALSE, variants that failed
    the quality filter will be included in the test.
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: -126.42857360839844
  sbg:y: 332
- id: null_model_file
  sbg:fileTypes: RDATA
  type: File
  label: Null model file
  doc: RData file containing a null model object. Run the GENESIS Null Model app to
    create this file.
  sbg:x: -14.14285659790039
  sbg:y: 397.4285583496094
- id: memory_gb
  type: float?
  label: Memory GB
  doc: Memory in GB per job.
  sbg:toolDefaultValue: '8'
  sbg:x: -126.28571319580078
  sbg:y: 493.8571472167969
- id: maf_threshold
  type: float?
  label: MAF threshold
  doc: Minimum minor allele frequency for variants to include in test. Only used if
    MAC threshold is NA.
  sbg:toolDefaultValue: '0.001'
  sbg:x: -13.714285850524902
  sbg:y: 564.7142944335938
- id: mac_threshold
  type: float?
  label: MAC threshold
  doc: Minimum minor allele count for variants to include in test. Recommend to use
    a higher threshold when outcome is binary or count data. To disable it set it
    to NA.
  sbg:toolDefaultValue: '5'
  sbg:x: -125.85713958740234
  sbg:y: 656.2857055664062
- id: cpu
  type: int?
  label: CPU
  doc: Number of CPUs for each job.
  sbg:toolDefaultValue: '1'
  sbg:x: -15.285714149475098
  sbg:y: 719
- id: disable_thin
  type: boolean?
  label: Disable Thin
  doc: Logical for whether to thin points in the QQ and Manhattan plots. By default,
    points are thinned in dense regions to reduce plotting time. If this parameter
    is set to TRUE, all variant p-values will be included in the plots, and the plotting
    will be very long and memory intensive.
  sbg:x: 1218.3565673828125
  sbg:y: 471.66802978515625
- id: variant_block_size
  type: int?
  label: Variant block size
  doc: Number of variants to read from the GDS file in a single block. For smaller
    sample sizes, increasing this value will reduce the number of iterations in the
    code. For larger sample sizes, values that are too large will result in excessive
    memory use.
  sbg:toolDefaultValue: '1024'
  sbg:x: -5.069672107696533
  sbg:y: 104.58606719970703
- id: thin_nbins
  type: int?
  label: Thin N bins
  doc: Number of bins to use for thinning.
  sbg:toolDefaultValue: '10'
  sbg:x: 1119.7178955078125
  sbg:y: 397.0429382324219
- id: thin_npoints
  type: int?
  label: Thin N points
  doc: Number of points in each bin after thinning.
  sbg:toolDefaultValue: '10000'
  sbg:x: 1220.2294921875
  sbg:y: 312.827880859375
- id: test_type
  type:
  - 'null'
  - type: enum
    symbols:
    - score
    - score.spa
    name: test_type
  label: Test type
  doc: Type of association test to perform. “Score” performs a score test and can
    be used with any null model. “Score.spa” uses the saddle point approximation (SPA)
    to provide more accurate p-values, especially for rare variants, in samples with
    unbalanced case:control ratios; “score.spa” can only be used if the null model
    family is “binomial”.
  sbg:toolDefaultValue: score
  sbg:x: -130.7656707763672
  sbg:y: 182.03883361816406
- id: out_prefix
  type: string
  label: Output prefix
  doc: Prefix that will be included in all output files.
  sbg:x: -114.17635345458984
  sbg:y: 838.3081665039062
- id: input_gds_files
  sbg:fileTypes: GDS
  type: File[]
  label: GDS files
  doc: GDS files with genotype data for variants to be tested for association. If
    multiple files are selected, they will be run in parallel. Files separated by
    chromosome are expected to have ‘chr##’ strings indicating chromosome number,
    where ‘##’ can be (1-24, X, Y). Output files for each chromosome will include
    the corresponding chromosome number.
  sbg:x: -450.07861328125
  sbg:y: -375.6904602050781
- id: truncate_pval_threshold
  type: float?
  label: Truncate pval threshold
  doc: Maximum p-value to display in truncated QQ and manhattan plots.
  sbg:x: 1010.1423950195312
  sbg:y: 505.93658447265625
- id: plot_mac_threshold
  type: int?
  label: Plot MAC threshold
  doc: Minimum minor allele count for variants or aggregate units to include in plots
    (if different from MAC threshold)
  sbg:x: 1152.8035888671875
  sbg:y: 610.734130859375
outputs:
- id: assoc_plots_1
  outputSource:
  - assoc_plots/assoc_plots
  sbg:fileTypes: PNG
  type: File[]?
  label: Association test plots
  doc: QQ and Manhattan Plots of p-values in association test results.
  sbg:x: 1666.43017578125
  sbg:y: 149.19834899902344
- id: assoc_combined
  outputSource:
  - assoc_combine_r/assoc_combined
  sbg:fileTypes: RDATA
  type: File[]?
  label: Association test results
  doc: RData file with data.frame of association test results (test statistic, p-value,
    etc.) See the documentation of the GENESIS R package for detailed description
    of outpu
  sbg:x: 1488
  sbg:y: 20.66666603088379
steps:
  define_segments_r:
    in:
    - id: segment_length
      source: segment_length
    - id: n_segments
      source: n_segments
    - id: genome_build
      source: genome_build
    out:
    - id: config
    - id: define_segments_output
    run: steps/define_segments_r.cwl
    label: Define Segments
    sbg:x: -199.3984375
    sbg:y: -70
  sbg_prepare_segments:
    in:
    - id: input_gds_files
      source:
      - sbg_gds_renamer/renamed_variants
    - id: segments_file
      source: define_segments_r/define_segments_output
    - id: variant_include_files
      source:
      - variant_include_files
    out:
    - id: gds_output
    - id: segments
    - id: aggregate_output
    - id: variant_include_output
    run: steps/sbg_prepare_segments.cwl
    label: SBG Prepare Segments
    sbg:x: 178.34030151367188
    sbg:y: -71.09950256347656
  assoc_single_r:
    in:
    - id: gds_file
      linkMerge: merge_flattened
      source:
      - sbg_prepare_segments/gds_output
      valueFrom: '$(self ? [].concat(self)[0] : self)'
    - id: null_model_file
      source: null_model_file
    - id: phenotype_file
      source: phenotype_file
    - id: mac_threshold
      source: mac_threshold
    - id: maf_threshold
      source: maf_threshold
    - id: pass_only
      source: pass_only
    - id: segment_file
      linkMerge: merge_flattened
      source:
      - define_segments_r/define_segments_output
      valueFrom: '$(self ? [].concat(self)[0] : self)'
    - id: test_type
      source: test_type
    - id: variant_include_file
      linkMerge: merge_flattened
      source:
      - sbg_prepare_segments/variant_include_output
      valueFrom: '$(self ? [].concat(self)[0] : self)'
    - id: segment
      linkMerge: merge_flattened
      source:
      - sbg_prepare_segments/segments
      valueFrom: '$(self ? [].concat(self)[0] : self)'
    - id: memory_gb
      default: 80
      source: memory_gb
    - id: cpu
      source: cpu
    - id: variant_block_size
      source: variant_block_size
    - id: out_prefix
      source: out_prefix
    - id: genome_build
      source: genome_build
    out:
    - id: configs
    - id: assoc_single
    run: steps/assoc_single_r.cwl
    label: Association testing Single
    scatter:
    - gds_file
    - variant_include_file
    - segment
    scatterMethod: dotproduct
    sbg:x: 502.1290283203125
    sbg:y: 170
  sbg_flattenlists:
    in:
    - id: input_list
      source:
      - assoc_single_r/assoc_single
      valueFrom: ${     var out = [];     for (var i = 0; i<self.length; i++){         if
        (self[i])    out.push(self[i])     }     return out }
    out:
    - id: output_list
    run: steps/sbg_flattenlists.cwl
    label: SBG FlattenLists
    sbg:x: 785.1242065429688
    sbg:y: 171.56935119628906
  sbg_group_segments:
    in:
    - id: assoc_files
      source:
      - sbg_flattenlists/output_list
    out:
    - id: grouped_assoc_files
    - id: chromosome
    run: steps/sbg_group_segments.cwl
    label: SBG Group Segments
    sbg:x: 1032.3333740234375
    sbg:y: 164
  assoc_combine_r:
    in:
    - id: chromosome
      source:
      - sbg_group_segments/chromosome
      valueFrom: '$(self ? [].concat(self) : self)'
    - id: assoc_type
      default: single
    - id: assoc_files
      source:
      - sbg_group_segments/grouped_assoc_files
      valueFrom: '$(self ? [].concat(self) : self)'
    - id: memory_gb
      default: 8
    - id: cpu
      default: 2
    out:
    - id: assoc_combined
    - id: configs
    run: steps/assoc_combine_r.cwl
    label: Association Combine
    scatter:
    - chromosome
    - assoc_files
    scatterMethod: dotproduct
    sbg:x: 1244
    sbg:y: 166.6666717529297
  assoc_plots:
    in:
    - id: assoc_files
      linkMerge: merge_flattened
      source:
      - assoc_combine_r/assoc_combined
      valueFrom: '$(self ? [].concat(self) : self)'
    - id: assoc_type
      default: single
    - id: plots_prefix
      source: out_prefix
    - id: disable_thin
      source: disable_thin
    - id: thin_npoints
      source: thin_npoints
    - id: thin_nbins
      source: thin_nbins
    - id: plot_mac_threshold
      source: plot_mac_threshold
    - id: truncate_pval_threshold
      source: truncate_pval_threshold
    out:
    - id: assoc_plots
    - id: configs
    run: steps/assoc_plots.cwl
    label: Association Plots
    sbg:x: 1496
    sbg:y: 293.3333435058594
  sbg_gds_renamer:
    in:
    - id: in_variants
      source: input_gds_files
    out:
    - id: renamed_variants
    run: steps/sbg_gds_renamer.cwl
    label: SBG GDS renamer
    scatter:
    - in_variants
    sbg:x: -251.79649353027344
    sbg:y: -257.9700012207031
hints:
- class: sbg:maxNumberOfParallelInstances
  value: '8'
requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement
sbg:projectName: GENESIS pipelines - DEMO
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1574269237
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/single-variant-association-testing/7
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1580990749
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/single-variant-association-testing/9
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584128968
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/single-variant-association-testing/30
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584372143
  sbg:revisionNotes: Final wrap
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593600790
  sbg:revisionNotes: 'New docker image: 2.8.0'
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593616797
  sbg:revisionNotes: Docker image update
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593694060
  sbg:revisionNotes: Input description updated at node level.
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593698114
  sbg:revisionNotes: Input descriptions updated
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1596468968
  sbg:revisionNotes: Benchmarking updated
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1598430184
  sbg:revisionNotes: Benchmarking updated
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1598430314
  sbg:revisionNotes: Benchmarking updated
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1598430982
  sbg:revisionNotes: Benchmarking updated
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1598431037
  sbg:revisionNotes: Benchmarking update
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1600674128
  sbg:revisionNotes: Benchmarking table updated
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602061917
  sbg:revisionNotes: Docker 2.8.1 and SaveLogs hint
- sbg:revision: 15
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602069994
  sbg:revisionNotes: SaveLogs update
- sbg:revision: 16
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602237468
  sbg:revisionNotes: Description updated
- sbg:revision: 17
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602248495
  sbg:revisionNotes: Input and output description updated
- sbg:revision: 18
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603462985
  sbg:revisionNotes: Variant_include_file
- sbg:revision: 19
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603796880
  sbg:revisionNotes: Config cleaning
- sbg:revision: 20
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603798276
  sbg:revisionNotes: Genome build default value updated
- sbg:revision: 21
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603903502
  sbg:revisionNotes: Config cleaning
- sbg:revision: 22
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603962964
  sbg:revisionNotes: Config cleaning
- sbg:revision: 23
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608903410
  sbg:revisionNotes: CWLtool compatible
- sbg:revision: 24
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608906354
  sbg:revisionNotes: Docker updated
sbg:image_url:
sbg:toolAuthor: TOPMed DCC
sbg:license: MIT
sbg:categories:
- GWAS
sbg:appVersion:
- v1.1
id: https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/boris_majic/genesis-pipelines-demo/single-variant-association-testing/24/raw/
sbg:id: boris_majic/genesis-pipelines-demo/single-variant-association-testing/24
sbg:revision: 24
sbg:revisionNotes: Docker updated
sbg:modifiedOn: 1608906354
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1574269237
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-pipelines-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 24
sbg:publisher: sbg
sbg:content_hash: a6e8c542d0614952a36cd5c9b20becf472c5f47199899e7b415db247a73727e5d
