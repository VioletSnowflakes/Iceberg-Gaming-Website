const commonData = {
  discord: "https://discord.gg/7hDQCEb",
  teamspeak: "ts3server://ts.iceberg-gaming.com/?port=9987",
  bct_modpack: "https://steamcommunity.com/sharedfiles/filedetails/?id=1501538330",
  webmaster: "[Name]"
}
const memberRoles = {
  bct: "[17th] Member",
  iceberg: "[ICE] Member",
  cgs: "[CGS] Member"
}

const roles = {
  iceberg: [memberRoles.iceberg, "[ICE] Recruiter", "[ICE] Admin", "[ICE] Owner", "[ICE] Webmaster"],
  bct: [memberRoles.bct, "[17th] 32nd LSG", "[17th] Ranger", "[17th] NCO", "[17th] Officer", "[17th] Alpha Company HQ"],
  cgs: [memberRoles.cgs, "[CGS] Officer", "[CGS] Owner"]
}
const rolesArray = [...roles.iceberg, ...roles.bct, ...roles.cgs];

const VALID_REMOVE_ROLES = { // What roles each role CAN remove. Example: ICE_OWNER can remove anyone with the [17th] Member, [ICE] Member, and [CGS] Member(division check in the function)
  ICE_OWNER: [memberRoles.bct, memberRoles.iceberg, memberRoles.cgs],
  ICE_ADMIN: [memberRoles.bct, memberRoles.iceberg, memberRoles.cgs],
  BCT_ALPHA_COMPANY_HQ: [memberRoles.bct],
  BCT_OFFICER: [memberRoles.bct],
  BCT_NCO: [memberRoles.bct],
  CGS_OWNER: [memberRoles.cgs],
  CGS_OFFICER: [memberRoles.cgs]
}
const INVALID_REMOVE_ROLES = { // What roles a certain role cannot remove if a user contains them
  ICE_OWNER: ["[ICE] Owner", "[ICE] Webmaster"],
  ICE_ADMIN: ["[ICE] Owner", "[ICE] Admin", "[ICE] Webmaster"],
  BCT_ALPHA_COMPANY_HQ: ["[ICE] Owner", "[ICE] Admin", "[ICE] Webmaster", "[17th] Alpha Company HQ"],
  BCT_OFFICER: ["[ICE] Owner", "[ICE] Admin", "[ICE] Webmaster", "[17th] Alpha Company HQ", "[17th] Officer"],
  BCT_NCO: ["[ICE] Owner", "[ICE] Admin", "[ICE] Webmaster", "[17th] Alpha Company HQ", "[17th] Officer", "[17th] NCO"],
  CGS_OWNER: ["[CGS] Owner"],
  CGS_OFFICER: ["[CGS] Owner", "[CGS] Officer"],
}
const VALID_CHANGE_ROLES = { // What roles each role can toggle
  BCT_NCO: ["[17th] Ranger", "[17th] 32nd LSG"],
  BCT_OFFICER: ["[17th] Ranger", "[17th] 32nd LSG", "[17th] NCO"],
  BCT_ALPHA_COMPANY_HQ: ["[17th] Ranger", "[17th] 32nd LSG", "[17th] NCO", "[17th] Officer"],
  ICE_OWNER: ["[17th] Ranger", "[17th] 32nd LSG", "[17th] NCO", "[17th] Officer", "[17th] Alpha Company HQ", "[ICE] Admin", "[ICE] Recruiter"],
  ICE_ADMIN: ["[17th] Ranger", "[17th] 32nd LSG", "[17th] NCO", "[17th] Officer", "[17th] Alpha Company HQ", "[ICE] Recruiter"],
  CGS_OFFICER: [],
  CGS_OWNER: ["[CGS] Owner", "[CGS] Officer"],
}
module.exports = {
  commonData,
  memberRoles,
  roles,
  rolesArray,
  VALID_REMOVE_ROLES,
  INVALID_REMOVE_ROLES,
  VALID_CHANGE_ROLES
}

