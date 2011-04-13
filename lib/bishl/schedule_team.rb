module BISHL
  class ScheduleTeam < Struct.new(:name, :wins,:losses, :ties,:otwins,:otlosses,:sowins,:points,:goalsfor,:goalsagainst,:goalsdiff)
  
    class << self
    
      def create(options={})
    
      end
  
    end
  end
end