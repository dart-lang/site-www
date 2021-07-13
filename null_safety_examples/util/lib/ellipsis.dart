dynamic blockEllipsis; // Use as replace="/=. blockEllipsis;/{ ... }/g"
dynamic ellipsis<T>() =>
    throw Exception('!'); // Use as replace="/ellipsis;?/.../g"
