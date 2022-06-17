// Shouldn't this be OK?
proc Top0 {
    input_channel: chan in u32;
    output_channel: chan out u32;
    config(input_channel: chan in u32, output_channel: chan out u32) {
        (input_channel, output_channel)
    }

    next(tok: token) {
        let (tok, value) = recv(tok, input_channel);
        let tok = send(tok, output_channel, value);
        ()
    }
}

// It makes sense that this is not OK, but should have a better error message
proc Top1 {
    config() {
        let (chan_p, chan_c) = chan u32;
        spawn Top0(chan_p, chan_c)();
        ()
    }

    next(tok: token, state: u32) {
        (state + u32:1,)
    }
}

// It makes sense that this is not OK, but should have a better error message
proc Top2<N: u32> {
    config() {
        let (chan_p, chan_c) = chan u32;
        spawn Top0(chan_p, chan_c)();
        ()
    }
    next(tok: token) {
        ()
    }
}
