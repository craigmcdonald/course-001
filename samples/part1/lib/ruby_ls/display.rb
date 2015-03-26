module RubyLS

  class Display

    def initialize(args)
      @long, @all, @paths, @invalid = args.values_at(:long, :all, :paths, :invalid)
    end

    def render
      change_dir
      if long
        puts long_listing
      else
        puts listing
      end
    end

    private 

    attr_reader :paths, :long, :all, :invalid

    def listing
      if paths.size > 1
        sort(paths).join("\n")
      else
        collect_dir_contents
      end
    end

    def change_dir
      Dir.chdir(paths[0]) if paths.size == 1
    end

    def collect_dir_contents
      return collect_invalid_dir_contents if invalid
      dir_glob.join("\n")
    end

    def collect_invalid_dir_contents
      dir_glob.collect {|f| "? "+f }.join("\n")
    end

    def dir_glob
      if all 
        sort(Dir.entries(Dir.pwd))
      else
        sort(Dir.glob("*"))
      end
    end

    def sort(array)
      array.sort_by do |x| 
        if x[0] == "." && !! x.match(/[a-z]/)
          x[1..-1]
        else
          x
        end
      end
    end

    def long_listing
      show_total_size+
      file_details.join("\n")+
      "\n"
    end

    def show_total_size
      if paths.size > 1
        ""
      else
        total_size.to_s+"\n"
      end
    end

    def total_size
      "total #{dir_glob.map {|file| File.stat(file).blocks}.reduce(:+) / 2}"
    end

    def file_details
      files = paths.size > 1 ? paths : dir_glob
      size = files.collect {|f| FileSummary.new(f).check_size}.max
      sort(files).collect do |file|
        FileSummary.new(file).stats(size)
      end
    end
  end

end