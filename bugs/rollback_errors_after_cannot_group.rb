# As of 14-Jul-2010 BoundingBox.move_past_bottom generates a 
# Prawn::Document::Snapshot::RollbackTransaction after Document.group has
# raised a Prawn::Errors::CannotGroup

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require "prawn"

def add_lines(pdf)
  100.times do |i|
    pdf.text("Line #{i}")
  end
end

Prawn::Document.generate("big_group.pdf", :page_layout => :portrait) do |pdf|
  # Raise and rescue a Prawn::Errors::CannotGroup
  begin
    pdf.group do
      add_lines(pdf)
    end
  rescue
    # This raise Prawn::Document::Snapshot::RollbackTransaction, but should just add a new page
    y = 0
    add_lines(pdf)
  end
end
