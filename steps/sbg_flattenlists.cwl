class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-pipelines-dev/sbg-flattenlists/6
baseCommand:
- echo
inputs:
- sbg:category: File inputs
  id: input_list
  type: File[]?
  label: Input list of files and lists
  doc: List of inputs, can be any combination of lists of files and single files,
    it will be combined into a single list of files at the output.
outputs:
- id: output_list
  doc: Single list of files that combines all files from all inputs.
  label: Output list of files
  type: File[]?
  outputBinding:
    outputEval: |-
      ${
          function flatten(files) {
              var a = [];
              for (var i = 0; i < files.length; i++) {
                  if (files[i]) {
                      if (files[i].constructor == Array) a = a.concat(flatten(files[i]))
                      else a = a.concat(files[i])
                  }
              }
              return a
          }

          {
              if (inputs.input_list) {
                  var arr = [].concat(inputs.input_list);
                  var return_array = [];
                  return_array = flatten(arr)
                  return return_array
              }
          }
      }
doc: |-
  ###**Overview** 

  SBG FlattenLists is used to merge any combination of single file and list of file inputs into a single list of files. This is important because most tools and the CWL specification doesn't allow array of array types, and combinations of single file and array need to be converted into a single list for tools that can process a list of files.

  ###**Input** 

  Any combination of input nodes that are of types File or array of File, and any tool outputs that produce types File or array of File.

  ###**Output** 

  Single array of File list containing all Files from all inputs combined, provided there are no duplicate files in those lists.

  ###**Usage example** 

  Example of usage is combining the outputs of two tools, one which produces a single file, and the other that produces an array of files, so that the next tool, which takes in an array of files, can process them together.
label: SBG FlattenLists
arguments:
- shellQuote: false
  position: 0
  valueFrom: '"Output'
- shellQuote: false
  position: 1
  valueFrom: is
- shellQuote: false
  position: 2
  valueFrom: now
- shellQuote: false
  position: 3
  valueFrom: a
- shellQuote: false
  position: 4
  valueFrom: single
- shellQuote: false
  position: 5
  valueFrom: list"
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 1000
  coresMin: 1
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.input_list)
- class: InlineJavascriptRequirement
  expressionLib:
  - |-
    var updateMetadata = function(file, key, value) {
        file['metadata'][key] = value;
        return file;
    };


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

    var toArray = function(file) {
        return [].concat(file);
    };

    var groupBy = function(files, key) {
        var groupedFiles = [];
        var tempDict = {};
        for (var i = 0; i < files.length; i++) {
            var value = files[i]['metadata'][key];
            if (value in tempDict)
                tempDict[value].push(files[i]);
            else tempDict[value] = [files[i]];
        }
        for (var key in tempDict) {
            groupedFiles.push(tempDict[key]);
        }
        return groupedFiles;
    };

    var orderBy = function(files, key, order) {
        var compareFunction = function(a, b) {
            if (a['metadata'][key].constructor === Number) {
                return a['metadata'][key] - b['metadata'][key];
            } else {
                var nameA = a['metadata'][key].toUpperCase();
                var nameB = b['metadata'][key].toUpperCase();
                if (nameA < nameB) {
                    return -1;
                }
                if (nameA > nameB) {
                    return 1;
                }
                return 0;
            }
        };

        files = files.sort(compareFunction);
        if (order == undefined || order == "asc")
            return files;
        else
            return files.reverse();
    };
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS pipelines - DEV
sbg:toolAuthor: Seven Bridges
sbg:cmdPreview: echo "Output is now a single list"
sbg:image_url:
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571049564
  sbg:revisionNotes:
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571049578
  sbg:revisionNotes: Import
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602061212
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606727480
  sbg:revisionNotes: CWLtool preparation
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606727545
  sbg:revisionNotes: CWLtool compatible
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608562910
  sbg:revisionNotes: CWLtool prep
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608905811
  sbg:revisionNotes: New docker
sbg:license: Apache License 2.0
sbg:categories:
- Other
sbg:toolkit: SBGTools
sbg:toolkitVersion: '1.0'
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-pipelines-dev/sbg-flattenlists/6
sbg:revision: 6
sbg:revisionNotes: New docker
sbg:modifiedOn: 1608905811
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1571049564
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-pipelines-dev
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 6
sbg:publisher: sbg
sbg:content_hash: a8ab04a2a11a3f02f5cb29025dbeebbe3bb71cc8f1eb7caafb6e2140373cc62f3
