# Show Xcode build summary.
xcode_summary.ignored_files = '**/Carthage/**'
xcode_summary.report 'build/reports/errors.json'

begin
  junit.parse("output/report.junit")
  junit.report
rescue
  warn("No junit output found")
end

# Warn about newly added, undocumented methods.
begin
  jazzy.path = "Documentation"
  jazzy.undocumented.each do |item|
    warn("Undocumented symbol #{github.html_link("#{item.symbol}")}")
  end
rescue
  warn("No documentation found")
end

# Code Coverage
begin
  slather.configure("MyApp.xcodeproj", "MyApp")
  slather.notify_if_coverage_is_less_than(minimum_coverage: 60)
  slather.notify_if_modified_file_is_less_than(minimum_coverage: 30)
  slather.show_coverage
rescue
  warn("No slather output found")
end
