return {
	-- BACKGROUND / FOREGROUND
	base00 = "{{colors.surface.default.hex}}", -- Main Background
	base01 = "{{colors.surface_container_low.default.hex}}", -- Lighter Background (Status bar)
	base02 = "{{colors.surface_container.default.hex}}", -- Selection Background
	base03 = "{{colors.on_surface_variant.default.hex}}", -- Comments
	base04 = "{{colors.on_surface.default.hex}}",
	base05 = "{{colors.on_surface.default.hex}}", -- Main Text
	base06 = "{{colors.on_surface_variant.default.hex}}",
	base07 = "{{colors.surface_bright.default.hex}}",

	-- SYNTAX COLORS (The important part)
	base08 = "{{colors.error.default.hex}}", -- Variables / Errors
	base09 = "{{colors.tertiary.default.hex}}", -- Constants / Numbers
	base0A = "{{colors.primary.default.hex}}", -- Keywords / Classes (Yellow/Gold usually)
	base0B = "{{colors.secondary.default.hex}}", -- Strings (Green/Cyan usually)

	-- FIX: Changed 'outline' to 'on_secondary_container' for better visibility
	base0C = "{{colors.on_secondary_container.default.hex}}", -- Escape chars / Regex

	-- FIX: Changed 'primary_container' to 'on_primary_container' (Functions)
	base0D = "{{colors.on_primary_container.default.hex}}",

	-- FIX: Changed 'secondary_container' to 'on_tertiary_container' (Keywords/Storage)
	base0E = "{{colors.on_tertiary_container.default.hex}}",

	-- FIX: Changed 'tertiary_container' to 'inverse_primary' (Delimiters/Misc)
	base0F = "{{colors.inverse_primary.default.hex}}",
}
