clear
close all
clc;
addpath('common/');
addpath('structure_classes/');
consts.level=0;
Consts;
Params;
%对于0值，我们给其颜色赋值为（0，0，0）
load('NYUv2_label2color.mat');
load(consts.splitsPath, 'trainNdxs');
dataset_dome='E:\\学习与研究\\图像研究\\语义分割\\数据集\\NY2_dataset\\dataset_dome\\';
% figure(1500);
% plotLegend4NYUv2(NYUv2_label2color);
% pause(3);
%  for i=1:consts.numImages
%     if ~consts.useImages(i)
%       continue;
%     end
%     if ~isin(i, trainNdxs)
%         load(sprintf(consts.predictResultFilename,i), 'predictStructureLabels');
%         structure_labelColor = NYUv2_label2color.mask_cmap(predictStructureLabels(:)+1,:);
%         structure_labelColor = reshape(structure_labelColor, [size(predictStructureLabels,1),size(predictStructureLabels,2),3]);
%         figure(i);
%         Im=imagesc(structure_labelColor); 
%         title(sprintf('structureLabelColor'));  
%         axis off image; caxis([0 5]);
%         pause(3);
%     else
%         continue;
%     end
%  end
dataset_fileDir=[dataset_dome 'depth\\'];
imagePath=[dataset_fileDir 'depth_%04d.jpg'];
 for i=1:consts.numImages
    if ~consts.useImages(i)
      continue;
    end
    load(sprintf(consts.imageDepthFilename ,i), 'imgDepth');
    imagesc(imgDepth);
%     Im=imagesc(imgDepth);
%     cmap=colormap('jet');
%     set(gca,'xtick',[],'xticklabel',[])
%     set(gca,'ytick',[],'yticklabel',[])
%     set(gca,'position',[0 0 1 1]);
%     saveas(gcf,sprintf(imagePath,i));
    
%     imgRegions = get_regions(i, params);
%     load(sprintf(consts.structureLabelsFilename, i), 'imgStructureLabels');
%     structure_labelColor = NYUv2_label2color.mask_cmap(imgStructureLabels(:)+1,:);
%     structure_labelColor = reshape(structure_labelColor, [size(imgStructureLabels,1),size(imgStructureLabels,2),3]);
%     imwrite(imgDepth,cmap,sprintf(imagePath,i));
%     figure(i);
%     imagesc(structure_labelColor);
%     title(sprintf('structureLabelColor'));  axis off image; caxis([0 5]);
%     pause(3);
end

% export_fig( sprintf('%s/legend.jpg', saveFolder) );
%% leaving blank

