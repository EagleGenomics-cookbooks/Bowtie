# tests for executables
%w(bowtie2-inspect-s bowtie2-align-l bowtie2-align-s bowtie2-build-l bowtie2-build-s bowtie2 bowtie2-build
   bowtie2-inspect).each do |file_executable|
  describe command("which #{file_executable}") do
    its(:exit_status) { should eq 0 }
  end

  describe command("#{file_executable} --version") do
    # its(:stdout) { should contain(ENV['BOWTIE_VERSION']) }
    its(:stdout) { should match(/2.2.9/) }
  end
end
