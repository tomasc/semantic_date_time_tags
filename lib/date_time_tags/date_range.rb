module DateTimeTags
  class DateRange

    def initialize date_from, date_to=nil
      @date_from = date_from
      @date_to = date_to
    end

    # ---------------------------------------------------------------------

    def spans_years?
      return false if @date_to.nil?
      @date_from.year != @date_to.year
    end

    def spans_months?
      @date_from.month != @date_to.month
    end

    def within_a_week?
      (@date_from - @date_to) <= 7
    end

    def one_day?
      @date_from == @date_to
    end

    # ---------------------------------------------------------------------

  end
end