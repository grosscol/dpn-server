# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

module BagMan

  class BagValidateJob < ActiveJob::Base
    queue_as :internal

    def perform(request, bag_location)
      unless request.cancelled
        bag = DPN::Bagit::Bag.new(bag_location)
        request.validity = bag.valid?
        request.save!
      end
    end
  end

end