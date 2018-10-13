module ApplicationHelper
	def tag_cloud(tags, classes)
		max = 0
		max = tags.sort_by(&:count).last
		tags.each do |tag|
			index = tag.count.to_f / max.count * (classes.size - 1)
			yield(tag, classes[index.round])
		end
	end
	def flaggable_url
		flaggable = controller.controller_name.singularize
		flags_path(flaggable_type: flaggable, flaggable_id: controller.instance_variable_get("@#{flaggable}").id)
	end
end
