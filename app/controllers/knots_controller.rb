class KnotsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_knot, only: [:show, :edit, :update, :destroy]
  before_action :login_check, only: [:create, :update, :destroy]

  # GET /knots
  # GET /knots.json
  def index
    @knots = Knot.order('updated_at DESC').all
  end

  # GET /knots/1
  # GET /knots/1.json
  def show
    @attatch = Attatch.new
    @uploadeds = Attatch.where(knot_id:params[:id]).order(:created_at)
    @knot.content = parse(@knot.content)
    for a in @uploadeds
      print "uploaded: ", a.file.url(:mediam)
    end



  end


  def fileupload

    params[:attatch][:files].each do |file|
      @attatch = Attatch.new(file: file)
      @attatch.knot_id = params[:knot_id]
      if @attatch.save
        flash[:success] = "fileupload ok."
      else
        flash[:success] = "fileupload fail."
      end
    end

    redirect_to knot_path(params[:knot_id])
  end

  # GET /knots/new
  def new
    @knot = Knot.new
  end

  # GET /knots/1/edit
  def edit
  end

  # POST /knots
  # POST /knots.json
  def create
    @knot = Knot.new(knot_params)

    respond_to do |format|
      if updateRelation(knot_params) && @knot.save
        format.html { redirect_to @knot, notice: 'Knot was successfully created.' }
        format.json { render :show, status: :created, location: @knot }
      else
        format.html { render :new }
        format.json { render json: @knot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /knots/1
  # PATCH/PUT /knots/1.json
  def update
    respond_to do |format|
      if updateRelation(knot_params) && @knot.update(knot_params)
        format.html { redirect_to @knot, notice: 'Knot was successfully updated.' }
        format.json { render :show, status: :ok, location: @knot }
      else
        format.html { render :edit }
        format.json { render json: @knot.errors, status: :unprocessable_entity }
      end
    end
  end

  def updateRelation(knot_params)
    begin
      items = []
      knot_params[:knots].split(/[,\s]+/).each do |p|
        k = Knot.find_by name:p
        items.push(k)
      end

      @knot.linked_from = items
      
    rescue
      false
    ensure
      true
    end
    
  end

  # DELETE /knots/1
  # DELETE /knots/1.json
  def destroy
    @knot.destroy
    respond_to do |format|
      format.html { redirect_to knots_url, notice: 'Knot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_knot
    @knot = Knot.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def knot_params
    params.require(:knot).permit(:name, :content, :knots)
  end

  def login_check
    if !isLogined()
      raise "session error"
    end
  end

  def attatch_params
    params.require(:attatch).permit(:file)
  end


  # def parse(content)
  #   content.gsub(/@img .*?@/) { |match|
  #     name = match.gsub(/@img (.*?)@/, '\1') 
  #     att = Attatch.where(file_file_name:name.gsub(/@img (.*?)@/, "\1"))
  #     begin
  #       "<img src=\"#{att[0].file.url(:medium)}\" />"
  #     rescue
  #       match
  #     end
  #   }
  # end

  def parse(content)
    parsed = ''
    isNoneBreakBlock = false
    isCodeBlock = false
    codeBlockContent = ''
    codeBlockName = ''

    content.split(/\n/).each do |line|
      line.gsub! /\s+$/, ''

      if isCodeBlock 
        if line =~ /^```(.*)?$/
          lexer = Rouge::Lexer.find codeBlockName
          if lexer 
            source = codeBlockContent
            formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
            parsed += formatter.format(lexer.lex(source))
          else
            parsed += '<div class="codeblock"><pre>' + "\n\n"
            parsed += codeBlockContent
            parsed += '</pre></div>'
          end

          isCodeBlock = false
          codeBlockContent = ''
          codeBlockName = ''
          next
        else
          codeBlockContent += line + "\n"
          next
        end
      else
        if line =~ /^```(.*)?$/
          codeBlockName = $1
          isCodeBlock = true
          next
        end
      end

      line.strip!

      if line =~ /^"""/
        isNoneBreakBlock = isNoneBreakBlock ? false : true
        next
      end

      if line =~ /^---/
        parsed += "<hr />"
        next
      end
        
      if line =~ /^(\={1,5})(.*)$/
        parsed += "<h#{$1.to_s.length}>#{$2}</h#{$1.to_s.length}>"
        next
      end

      if /``(?<code>.*?)``/ =~ line
        line = "#{special($`)}<span class=\"codeline\">#{safeHtml(code)}</span>#{special($')}"
        line += "<br />" unless isNoneBreakBlock
        parsed += line + "\n"
        next
      end

      if line =~ /@img (.*?)@/
        att = Attatch.where(file_file_name:"#{$1}")
        begin
          parsed += "<img src=\"#{att[0].file.url(:medium)}\" />"
        rescue
          parsed += "no file."
        end
        next
      end

      special line

      if line =~ /\(\((?:(.*?)(?: (.*?))?)\)\)/
        rs = Extension.new(@config).build($1, $2)
        line.gsub! $&, rs
      end

      line += "<br />" unless isNoneBreakBlock

      parsed += line + "\n"
    end

    parsed
  end 

  def special str
    str.gsub! /''(.*?)''/, "<strong>\\1</strong>"
    str.gsub! /__(.*?)__/, "<u>\\1</u>"
    str.gsub! /\/\/(.*?)\/\//, "<i>\\1</i>" 
    str.gsub! /~~(.*?)~~/, "<del>\\1</del>"
    str
  end
end
