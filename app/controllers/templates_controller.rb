class TemplatesController < ApplicationController

def index
  @images = Image.all
end

def new
end

def create
  #create new template name, fields template, field
  
  #Create a new template
  #@template = Template.new()

  
  byebug
end

def show
end




end