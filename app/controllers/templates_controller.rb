class TemplatesController < ApplicationController

def index
  @images = Image.all
end

def new
end

def create
  byebug
end

def show
end




end