local utils = require("projektgunnar.utils")

local M = {}

function M.update_packages_in_solution()
	local projects = utils.get_all_projects_in_solution()

	-- ask user to select a project
	local selectedIndexInProjectList = vim.fn.inputlist(projects)

	-- run the update nugets command for the selected package
	local outdatedNugets = vim.fn.system(
		"dotnet list " .. projects[selectedIndexInProjectList] .. " package --outdated  | awk '/>/{print $2}'"
	)

	-- print the output of the command, if it's empty, print that it is empty
	if outdatedNugets == "" then
		print("\nNo outdated nugets found")
		return
	end
	print("\n" .. outdatedNugets)

	-- run the update command for each outdated nugets
	local resultOfNugetUpdate = {}

	-- get the total number of outdated nugets from outdatedNugets
	local totalNumberOfOutdatedNugets = 0
	for _ in string.gmatch(outdatedNugets, "%S+") do
		totalNumberOfOutdatedNugets = totalNumberOfOutdatedNugets + 1
	end

	-- update each nuget and print the progress
	local currentNumberOfOutdatedNugets = 0
	for outdatedNuget in string.gmatch(outdatedNugets, "%S+") do
		currentNumberOfOutdatedNugets = currentNumberOfOutdatedNugets + 1
		print("Updating nuget " .. currentNumberOfOutdatedNugets .. " of " .. totalNumberOfOutdatedNugets)
		resultOfNugetUpdate =
			vim.fn.system("dotnet add " .. projects[selectedIndexInProjectList] .. " package " .. outdatedNuget)
	end

	-- print result of update in result buffer
	utils.open_result_buffer(resultOfNugetUpdate)
end

return M
