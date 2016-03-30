# == Schema Information 
# 
#  Table Name: master_courses 
#  
#  id									:integer					 	not null, primary key 
#  subject 		 				:string 				   	not null/blank, 2 or more characters 
#  number			 				:integer 				   	not null/blank, 1000..9999 range 
#  created_at  				:datetime				   	not null
#  updated_at  				:datetime 				 	not null 

# To track all courses + reviews ever, just just given a term 

include CourseReviewsHelper
class MasterCourse < ActiveRecord::Base

	validates :subject, presence: true 
	validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 9999 }


	def as_json(options=[])
		result = [] 
		if options.include?(:include_reviews)
			# Accumulate all reviews 
			reviews = CourseReview.where(master_course_id: self.id)
			reviews.each do |r| 
				result.push(r.as_json)
			end
			course_reviews = review_statistics(reviews)
			return super({ only: [:subject, :number] }).merge({ review_statistics: course_reviews, reviews: result, })
		end 
	end 


end