clc;clear;


box_size = '200Mpc';
data_resolution = '1024';
box_num = '1';

res = 201
dens=zeros(res,res,res);
label_bw=zeros(res,res,res);

ref_path = ['/storage/filament/works_v2/result_filament/' box_size '_' box_num '_' data_resolution '/'];

struc = dir(ref_path);
struc = struc(~ismember({struc.name},{'.','..'}));
%%
for k = 1:1
%for k = 1:2
    peak_num = k

    dens_path = [ref_path num2str(peak_num) '/dens_img/'];

    for i=0:res-1
        dens(:,:,i+1) = flipud(rgb2gray(imread([dens_path num2str(i)])));
    end

    label_bw = find_connected_comp_v1(dens,res);
      
    save_path = [ref_path num2str(peak_num) '/label/bw/'];
    if ~exist(save_path, 'dir')
       mkdir(save_path)
    end

    
    for i = 1:res
        for j = 1:res
            for k = 1:res
                
    
end

%%
function filament = find_connected_comp_v1(dens,res)

    for i = 1:res
        for j =1:res
            for k =1:res
                if dens(i,j,k) < 64
                    label(i,j,k) = 0;
                else
                    label(i,j,k) = 1;
                end
            end
        end
    end

    
    CC = bwconncomp(label,26);

    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    label(CC.PixelIdxList{idx}) = 2;


    for i = 1:res
        for j =1:res
            for k =1:res
                if label(i,j,k) == 2
                    label(i,j,k) = 1;
                else
                    label(i,j,k) = 0;
                end
            end
        end
    end


label= double(bwmorph3(label,'clean'));

filament = double(bwskel(logical(label),'MinBranchLength',8));

end