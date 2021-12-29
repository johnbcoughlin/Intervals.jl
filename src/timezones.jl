using .TimeZones

function Interval{T}() where T <: ZonedDateTime
    return Interval{T, Open, Open}(T(0, tz"UTC"), T(0, tz"UTC"))
end

function TimeZones.astimezone(i::Interval{ZonedDateTime, L, R}, tz::TimeZone) where {L,R}
    return Interval{ZonedDateTime, L, R}(astimezone(first(i), tz), astimezone(last(i), tz))
end

function TimeZones.timezone(i::Interval{ZonedDateTime})
    if timezone(first(i)) != timezone(last(i))
        throw(ArgumentError("Interval $i contains mixed timezones."))
    end
    return timezone(first(i))
end

function TimeZones.astimezone(i::AnchoredInterval{P, ZonedDateTime, L, R}, tz::TimeZone) where {P,L,R}
    return AnchoredInterval{P, ZonedDateTime, L, R}(astimezone(anchor(i), tz))
end

TimeZones.timezone(i::AnchoredInterval{P, ZonedDateTime}) where P = timezone(anchor(i))

function description(interval::AnchoredInterval{P, ZonedDateTime, L, R}, s::String) where {P,L,R}
    return string(
        L === Closed ? '[' : '(',
        description(anchor(interval), abs(P), s),
        anchor(interval).zone.offset,
        R === Closed ? ']' : ')',
    )
end
