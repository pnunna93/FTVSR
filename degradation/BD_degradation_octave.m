pkg load image;
data_path='/workspace/vimeo/vimeo_septuplet/sequences_BD/';
output_path='/workspace/vimeo/vimeo_septuplet/sequences_BD_crf15/';
scale = 4;
sigma = 1.6;
kernelsize = ceil(sigma * 3) * 2 + 2;
kernel = fspecial('gaussian', kernelsize, sigma);
imgDataDir  = dir(data_path);
for i = 1:length(imgDataDir)
    if(isequal(imgDataDir(i).name,'.')||... % 去除系统自带的两个隐文件夹
       isequal(imgDataDir(i).name,'..')||...
       ~imgDataDir(i).isdir)                % 去除遍历中不是文件夹的
           continue;
    end
    imgDir = dir([data_path imgDataDir(i).name]);
    for j =1:length(imgDir)                 % 遍历所有图片
        if(isequal(imgDir(j).name,'.')||... % 去除系统自带的两个隐文件夹
           isequal(imgDir(j).name,'..')||
           ~imgDir(j).isdir)   % 去除遍历中不是文件夹的
           continue;
        end
        realImgDir=dir([data_path imgDataDir(i).name '/' imgDir(j).name]);
        for k=1:length(realImgDir)
            if(isequal(realImgDir(k).name,'.')||... % 去除系统自带的两个隐文件夹
               isequal(realImgDir(k).name,'..'))   % 去除遍历中不是文件夹的
               continue;
            end
            img = imread([data_path imgDataDir(i).name '/' imgDir(j).name '/' realImgDir(k).name]);
            img = imfilter(img, kernel, 'replicate');
            img = img(scale/2:scale:end-scale/2, scale/2:scale:end-scale/2, :);
            if ~exist([output_path imgDataDir(i).name '/'], 'dir')
                mkdir([output_path imgDataDir(i).name '/']);
            end
            if ~exist([output_path imgDataDir(i).name '/' imgDir(j).name '/'], 'dir')
                mkdir([output_path imgDataDir(i).name '/' imgDir(j).name '/']);
            end
            imwrite(img, [output_path imgDataDir(i).name '/' imgDir(j).name '/' realImgDir(k).name]);
        end
    end
end
