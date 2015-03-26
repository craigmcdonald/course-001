module RubyLS

  class FileSummary

      attr_reader :fs, :path

    def initialize(path)
      @path = path
      @fs = File::Stat.new(path)
    end

    def check_size
      fs.size.to_s.length
    end

    def stats(rjust=4)
      permissions+" "+
      hardlinks+" "+
      owner+" "+
      group+" "+
      size(rjust)+" "+
      ctime+" "+
      path
    end

    private 

    def ctime
      fs.ctime.strftime("%b %e %H:%M")
    end

    def size(chars)
      fs.size.to_s.rjust(chars)
    end

    def group
      Etc.getgrgid(fs.gid).name
    end

    def owner
      Etc.getpwuid(fs.uid).name
    end

    def hardlinks
      fs.nlink.to_s
    end

    def permissions
      string = sprintf("%o", fs.mode)
      is_dir(string)+permissions_from_octal(string[-3..-1])
    end

    def is_dir(oct)
      oct[0] == "4" ? "d" : "-"
    end

    def permissions_from_octal(oct)
      oct.split(//).collect do |c|
        c == "7" ? "rwx" : c == "6" ? "rw-" : c == "5" ? "r-x" : c == "4" ? "r--" : "-"
      end.join
    end

  end

end