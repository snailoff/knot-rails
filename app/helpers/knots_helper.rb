module KnotsHelper

	def knots_s(knot)
		r = []
		knot.linked_from.each do |p|
			r << p.name
		end
		r.join(", ")
	end

	def markdown(content)
		maruku = Maruku.new(content)
		maruku.to_html
	end
end
