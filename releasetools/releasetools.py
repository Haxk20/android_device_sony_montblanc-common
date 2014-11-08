# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Add backup for efs during flashing of ota-zip"""

import common

def Thanks(self):
	self.script.AppendExtra('ui_print("    _    ___  ____  ____    ____   ___  ");')
	self.script.AppendExtra('ui_print("   / \  / _ \/ ___||  _ \  | ___| / _ \ ");')
	self.script.AppendExtra('ui_print("  / _ \| | | \___ \| |_) | |___ \| | | |");')
	self.script.AppendExtra('ui_print(" / ___ \ |_| |___) |  __/   ___) | |_| |");')
	self.script.AppendExtra('ui_print("/_/   \_\___/|____/|_|     |____(_)___/ ");')
	self.script.AppendExtra('ui_print("========================================");')
	self.script.AppendExtra('ui_print("    Author : AGONTUK");')
	self.script.AppendExtra('ui_print("    Credits :");')
	self.script.AppendExtra('ui_print("    AOSX Team, 95A31, munjeni, FXP Team");')
	self.script.AppendExtra('ui_print("========================================");')

def FullOTA_Assertions(self):
	Thanks(self)

def IncrementalOTA_Assertions(self):
	Thanks(self)

