##
# This file is part of IMS Caliper Analytics™ and is licensed to
# IMS Global Learning Consortium, Inc. (http://www.imsglobal.org)
# under one or more contributor license agreements.  See the NOTICE
# file distributed with this work for additional information.
#
# IMS Caliper is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# IMS Caliper is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with this program. If not, see http://www.gnu.org/licenses/.

require_relative '../entity'
require_relative '../entity_type'

#
# Representation of a score.
#
module Caliper
  module Entities
    module Assign
      class Score < Entity

        caliper_type Caliper::Entities::EntityType::SCORE

        caliper_property :attempt,         type: Caliper::Entities::EntityType::ATTEMPT
        caliper_property :comment
        caliper_property :maxScore
        caliper_property :scoreGiven
        caliper_property :scoredBy,         type: Caliper::Entities::EntityType::AGENT

      end
    end
  end
end
