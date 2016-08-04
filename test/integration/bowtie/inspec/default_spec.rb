# tests for executables
%w(bowtie-inspect-s bowtie-align-l bowtie-align-s bowtie-build-l bowtie-build-s bowtie bowtie-build
   bowtie-inspect).each do |file_executable|
  describe command("which #{file_executable}") do
    its(:exit_status) { should eq 0 }
  end

  describe command("#{file_executable} --version") do
    its(:stdout) { should match(/1.1.1/) }
  end
end
