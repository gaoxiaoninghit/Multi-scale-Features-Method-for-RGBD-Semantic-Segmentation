Params;
consts.level=0;
Consts;
for ii=909:1200
    imgRegions = get_regions(ii, params);
    load(sprintf(consts.structureLabelsFilename, ii), 'imgStructureLabels');
    structureLabels = get_labels_from_regions(imgRegions, imgStructureLabels);
  pause(3);
end