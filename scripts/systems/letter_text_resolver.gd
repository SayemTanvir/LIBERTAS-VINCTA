extends RefCounted
class_name LetterTextResolver
## Selects the correct route-aware text variant for Part II letters (VIII-XIII).
## Letters I-VII are identical across all routes.

enum RouteContext { UNTOUCHED, VANTREE, PARTIAL_MERCY }

## Determine the player's current route context based on which senses are restored.
static func get_route_context() -> RouteContext:
	if FreedomLedger.memory_restored:
		return RouteContext.VANTREE
	if FreedomLedger.hearing_restored and FreedomLedger.sight_restored:
		return RouteContext.PARTIAL_MERCY
	if FreedomLedger.hearing_restored and not FreedomLedger.sight_restored:
		return RouteContext.VANTREE
	return RouteContext.UNTOUCHED

## Resolve the correct text for a given letter ID.
## For letters 1-7, returns the base "text" field.
## For letters 8-13, selects the route-appropriate variant.
static func resolve_text(letter_id: String, metadata: Dictionary) -> String:
	var parts := letter_id.split("_")
	var index := int(parts[-1]) if parts.size() >= 2 else 0
	if index <= 7:
		return str(metadata.get("text", ""))
	var context := get_route_context()
	var key: String
	match context:
		RouteContext.UNTOUCHED:
			key = "text_untouched"
		RouteContext.VANTREE:
			key = "text_vantree"
		RouteContext.PARTIAL_MERCY:
			key = "text_partial_mercy"
		_:
			key = "text_vantree"
	return str(metadata.get(key, metadata.get("text", "")))
