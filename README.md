# My Garmin IQ Components library

These are my custom components for watch face creation with Monkey C. Components are hand coded, they don't use the Garmin IQ's layout system, which performed poorly for my taste.

## Notes

-   Full sized second hand works, best execution time: 8549 with -O 2
    optimization.
-   Storing and using BufferedBitmap is noticably faster than using
    BufferedBitmapReference, around ~500 ns.
-   Prefetching the DC of `BufferedBitmap` is not particularily faster.
