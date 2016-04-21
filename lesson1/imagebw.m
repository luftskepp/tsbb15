function [] = imagebw(im,type0)
    if(type0==0)
        imshow(im,[0 255]);
        colorbar; colormap gray;
    else
        imshow(im,[min(im(:)) max(im(:))]);
        colorbar; colormap gray;    
    end;
return;