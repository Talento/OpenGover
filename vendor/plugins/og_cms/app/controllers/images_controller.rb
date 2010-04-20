class ImagesController < ApplicationController

    def crop
      id = params[:id]
      x = params[:x]
      y = params[:y]
      width = params[:width]
      height = params[:height]
      i = Image.find id
      i.crop x,y,width,height
      render :update do |page|
        page.call('image_cropped',id);
      end
    end

    def rotate
      id = params[:id]
      angle = params[:angle]
      i = Image.find id
      i.rotate angle.to_i
      render :update do |page|
        page.call('image_rotated',id);
      end
    end

end