module Applicative.Function exposing (..)

{-| Instances of Functor and Applicative for functions.
-}

-- Functor


{-| Function composition; a prefix synonym for `<<`.
-}
fmap : (a -> b) -> (p -> a) -> (p -> b)
fmap =
    (<<)


{-| An infix synonym for `fmap`.
-}
(<$>) : (a -> b) -> (p -> a) -> (p -> b)
(<$>) =
    fmap


{-| Replace all locations in the input with the same value.
-}
(<$) : a -> (p -> b) -> (p -> a)
(<$) =
    fmap << always


{-| Flipped version of `<$.`
-}
($>) : (p -> a) -> b -> (p -> b)
($>) =
    flip (<$)



-- Applicative


{-| Lift a value.
-}
pure : a -> (p -> a)
pure =
    always


{-| Sequential application.
-}
apply : (p -> (a -> b)) -> (p -> a) -> (p -> b)
apply f g x =
    f x (g x)


{-| Sequential application.
-}
(<*>) : (p -> (a -> b)) -> (p -> a) -> (p -> b)
(<*>) =
    apply


{-| Sequence actions, discarding the value of the first argument.
-}
(*>) : (p -> a) -> (p -> b) -> (p -> b)
(*>) =
    liftA2 (flip always)


{-| Sequence actions, discarding the value of the second argument.
-}
(<*) : (p -> a) -> (p -> b) -> (p -> a)
(<*) =
    liftA2 always


{-| A variant of `<*>` with the arguments reversed.
-}
(<**>) : (p -> a) -> (p -> (a -> b)) -> (p -> b)
(<**>) =
    liftA2 (\a f -> f a)


{-| Lift a function to actions. This function may be used as a value for `fmap`.
-}
liftA : (a -> b) -> (p -> a) -> (p -> b)
liftA f a =
    pure f <*> a


{-| Lift a binary function to actions.
-}
liftA2 : (a -> b -> c) -> (p -> a) -> (p -> b) -> (p -> c)
liftA2 f aa ab x =
    f (aa x) (ab x)


{-| Lift a ternary function to actions.
-}
liftA3 : (a -> b -> c -> d) -> (p -> a) -> (p -> b) -> (p -> c) -> (p -> d)
liftA3 f aa ab ac =
    liftA2 f aa ab <*> ac
