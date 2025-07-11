Function Add-Boost {
    <#
    .SYNOPSIS
        Add boost library.
    #>
    [OutputType()]
    param(
    )
    begin {
    }
    process {
        $url = "https://archives.boost.io/release/1.72.0/source/boost_1_72_0.zip"
        Invoke-WebRequest $url -OutFile "boost.zip"
        Expand-Archive -Path "boost.zip" -DestinationPath "../deps"
    }
    end {
    }
}