function [ result ] = gray2rgb( image )
    img_size = size(image);
    result = uint8(zeros(img_size(1), img_size(2), 3));
    
    for i = 1:3
        result(:, :, i) = image;
    end
end