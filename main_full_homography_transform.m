% blends multiple cylindrically warped homographied images into a single image

% VLFeat is used to extract SIFT features
% run('/Users/eyoong/Downloads/vlfeat/toolbox/vl_setup');
run('VLFeat/vlfeat-0.9.20/toolbox/vl_setup');

% specify directory and extension type
%directory='Test_Images/'; extension='JPG';
directory='Lecture_Hall/'; extension='JPG';

% load images
[images] = load_images(directory, extension);

for i = 1:length(images)
    images{i}=imrotate(images{i},270);
    images{i}=imresize(images{i}, [480,640]);
end

% shorter data set for testing
temp{1}=images{1};
temp{2}=images{2};
temp{3}=images{3};
images = temp;

% cylindrical transform of the entire image set
focal_length = 663.3665;
[images] = cylindrical_transform_image_set(images, focal_length);
[images] = crop_left_side(images,20);

% SIFT RANSAC parameters
numsamples_homography = 4; % min 4
iterations_ransac = 500;    % more is better but takes longer O(n)
threshold_inliers = 12;    % how close do the inliers need to be to be considered inliers

% compute pairwise alignments and merge images
[panorama] = merge_images(images, numsamples_homography, iterations_ransac, threshold_inliers, @alpha_blend);

figure
imshow(panorama);
imwrite(panorama,'lecture_hall_without_full_transform.png');
